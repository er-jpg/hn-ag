ExUnit.start()

Mox.defmock(HnService.HackerNewsApiBehaviourMock, for: HnService.HackerNewsApiBehaviour)

Application.put_env(:hn_service, :hn_api, HnService.HackerNewsApiBehaviourMock)
