function Get_Clean_Code_News([Uint32]$index) {
    $result = [xml](Invoke-WebRequest "http://blog.cleancoder.com/atom.xml")
    $html = New-Object -Com "HTMLFile"
    $html.IHTMLDocument2_write($result.feed.entry[$index].content.'#cdata-section')
    $texto = $html.all.tags('p') | % innerText
    $result.feed.entry[$index].title.'#cdata-section'
    $texto -replace "[???]",""
}

function List_Clean_Code_News {
    echo "News ..."
    $result = [xml](Invoke-WebRequest "http://blog.cleancoder.com/atom.xml")
    $posts = $result.feed.entry
    foreach($post in $posts){
        echo "$($posts.IndexOf($post)) - $($post.title.'#cdata-section')"
    }
}
function Render_Html { $input > out.html; start out.html; sleep 1; rm out.html }

function List_Gizmodo_News {
    $gizmodo = [xml](Invoke-WebRequest "https://gizmodo.uol.com.br/feed/")
    $posts = $gizmodo.rss.channel.item
    foreach($post in $posts){
        echo "$($posts.IndexOf($post)) - $($post.title)"
    }
}

function Get_Gizmodo_News([Uint32]$index) {
    $gizmodo = [xml](Invoke-WebRequest "https://gizmodo.uol.com.br/feed/")
    $gizmodo.rss.channel.item[$index].encoded.'#cdata-section' | Render_Html
}