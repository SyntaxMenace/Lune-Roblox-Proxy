# Lune Roblox Proxy server

This project is unmanagable and was abandoned right after release. Thanks!

> Hosting on your local machine? Check out [Ngrok](https://www.ngrok.com)!

## Usage
This project does not support direct Roblox api support, <br>
(e.g. `groups.proxysite.xyz/{id}/groups/roles`)

requests must be done via `site.xyz/{Service}`, refer to the docs for further usage. <br>
e.g.
```lua
HttpService:GetAsync(
  "https://site.xyz/GetUserGroupRole",
  false,
  {
    userId = 1,
    groupid = 1
  }
)
```

> Q: Why?
> 
> A: This is for Ngrok support and I couldn't find out how to manage sub-domains in lune c:

## Roadmap
### APIS
  #### Group-specific
  - [x] Read group rank & roles for given UserID `site.xyz/GetUserGroupRole` [GET]
  - [ ] Fall-back to the Roblox APIs if the requested service is not *yet* implemented.

  #### Functionality
  - [ ] RateLimiting
  - [ ] At least 5s of caching data for high-loads.
