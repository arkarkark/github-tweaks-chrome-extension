# Make it so that all links to issues on an issues (or pulls) results page open in a new tab.

# inspiration	from: http://stackoverflow.com/questions/12042852

config =
  childList: true
  subtree: true

regex = new RegExp("/(issues|pull)/[0-9]")

foundLink = (n) ->
  href = n.getAttribute('href')
  if href?.search(regex) != -1
    return if n.getAttribute('target') == '_blank'
    n.setAttribute('target', '_blank')
    n.addEventListener('click', (event) ->
      window.open(href, '_blank')
      event.preventDefault()
    )

# Traverse 'rootNode' and its descendants and modify '<a>' tags
modifyLinks = (rootNode) ->
  [].slice.call(document.querySelectorAll('a')).forEach((n) -> foundLink(n))

observer = new MutationObserver((mutations) ->
  mutations.some((mutation) ->
    if mutation.addedNodes
      [].slice.call(mutation.addedNodes).forEach((node) -> modifyLinks(node))
  )
)

observer.observe(document.body, config)
# modifyLinks(document.body)
