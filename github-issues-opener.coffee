# Make it so that all links to issues on an issues (or pulls) results page open in a new tab.
# Also make links to not github urls open in a new tab too.
#
# inspiration	from: http://stackoverflow.com/questions/12042852

config =
  childList: true
  subtree: true

paths = new RegExp('/(issues|pull)')
regex = new RegExp('/(issues|pull)/([0-9]+)')
hasNotRegex = new RegExp('^https?')
notRegex = new RegExp('^https?://[^/]*github.com')

getIssueId = (url) ->
  match = url.match(regex)
  if match && match[2]
    match[2]
  else
    null

matches = (str, reg) ->
  str.search(reg) != -1

foundLink = (n, currentIssueId) ->
  href = n.getAttribute('href')
  return unless href && href != '#'
  linkIssueId = getIssueId(href)
  return if currentIssueId == linkIssueId

  if matches(href, regex) || (matches(href, hasNotRegex) && !matches(href, notRegex))
    el = document.createElement('a')
    el.innerHTML = n.innerHTML
    el.addEventListener('click', (event) ->
      console.log(event)
      if event.button == 1 || (event.button == 0 && event.metaKey)
        window.open(href, '_blank')
      else
        chrome.runtime.sendMessage({message: 'openIssue', issueId: linkIssueId, href: href})
      event.preventDefault()
    )
    n.parentNode.replaceChild(el, n)

# Traverse 'rootNode' and its descendants and modify '<a>' tags
modifyLinks = (rootNode, currentIssueId) ->
  [].slice.call(document.querySelectorAll('a')).forEach((n) -> foundLink(n, currentIssueId))

currentIssueId = getIssueId(String(window.location))

observer = new MutationObserver((mutations) ->
  mutations.some((mutation) ->
    if mutation.addedNodes
      if window.location.pathname.search(paths) != -1
        [].slice.call(mutation.addedNodes).forEach((node) -> modifyLinks(node, currentIssueId))
  )
)


observer.observe(document.body, config)
