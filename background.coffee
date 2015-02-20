# to access the tabs etc...

regex = new RegExp('/(issues|pull)/([0-9]+)')

getIssueId = (url) ->
  match = url.match(regex)
  if match && match[2]
    match[2]
  else
    null

openIssue = (issueId, href) ->
  # first see if we have a tab with that issue in it.
  chrome.tabs.query({title: "*#{issueId}*"}, (tabs) ->
    for tab in tabs
      tabIssueId = getIssueId(tab.url)
      if tabIssueId == issueId
        chrome.tabs.update(tab.id, {active: true})
        chrome.windows.update(tab.windowId, {focused: true})
        return
    # did not find tab. so just open a new window with it.
    window.open(href, '_blank')
  )

chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->
  openIssue(request.issueId, request.href) if request.message == 'openIssue'
)
