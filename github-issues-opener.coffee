# Make it so that all links to issues on an issues (or pulls) results page open in a new tab.
# Also make links to not github urls open in a new tab too.
#
# inspiration	from: http://stackoverflow.com/questions/12042852

config =
  childList: true
  subtree: true

paths = new RegExp('/(issues|pull)')
regex = new RegExp('/(issues|pull)/[0-9]')
hasNotRegex = new RegExp('^https?')
notRegex = new RegExp('^https?://[^/]*github.com')

matches = (str, reg) ->
  str.search(reg) != -1

foundLink = (n) ->
  href = n.getAttribute('href')
  return unless href
  if matches(href, regex) || (matches(href, hasNotRegex) && !matches(href, notRegex))
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
      if window.location.pathname.search(paths) != -1
        [].slice.call(mutation.addedNodes).forEach((node) -> modifyLinks(node))
  )
)

observer.observe(document.body, config)
