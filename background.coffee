# background page to access the tabs etc...

regex = new RegExp('github\.com/[^/]+/[^/]+/(issues|pull)/([0-9]+)')

getIssueId = (url) ->
  return null unless url
  match = url.match(regex)
  if match && match[2]
    match[2]
  else
    null

# should use $q here...
findTabForIssue = (issueId, success, failure, {ignoreTabId}={}) ->
  chrome.tabs.query({title: "*#{issueId}*"}, (tabs) ->
    for tab in tabs
      tabIssueId = getIssueId(tab.url)
      if tabIssueId == issueId && tab.id != ignoreTabId
        return success?(tab)
    failure?()
  )

selectTab = (tab, {url}={}) ->
  update = {active: true}
  update.url = url if url
  chrome.tabs.update(tab.id, update)
  chrome.windows.update(tab.windowId, {focused: true})

openIssue = (issueId, href) ->
  # first see if we have a tab with that issue in it.
  findTabForIssue(
    issueId
    (tab) -> selectTab(tab)
    -> window.open(href, '_blank') # did not find tab. so just open a new window with it.
  )

chrome.runtime.onMessage.addListener((request, sender, sendResponse) ->
  openIssue(request.issueId, request.href) if request.message == 'openIssue'
)

chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) ->
  return unless changeInfo.status == 'loading'

  issueId = getIssueId(changeInfo.url)
  if issueId
    findTabForIssue(
      issueId,
      (matchingTab) ->
        chrome.tabs.remove(tabId)
        selectTab(matchingTab, {url: changeInfo.url}) if tab.active
      null
      {ignoreTabId: tabId}
    )
)
