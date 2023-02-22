# AutoVPN.spoon

Spoon to connect to VPN automatically

## Prerequisite
- `otp` luarocks package
  ```sh
    luarocks install otp OPENSSL_DIR=/usr/local/Cellar/openssl@1.1/1.1.1t CRYPTO_DIR=/usr/local/Cellar/openssl@1.1/1.1.1t
  ```

## Installation

- manually using zip file

1. downlaod AutoVPN.spoon.zip file from ./Spoons dir and extract it in ~/.hammerspoon/Spoons
2. In your hammerspoon `init.lua` add the snippet
  ```lua
  local autovpn = hs.loadSpoon("AutoVPN")
  autovpn.start()
  ```

- using `SpoonInstall`
1. Add the snippet in `init.lua`
```lua
local spoonInstall = hs.loadSpoon("SpoonInstall")
spoonInstall.repos = {
  default = {
    url = "https://github.com/Hammerspoon/Spoons",
    desc = "Main Hammerspoon Spoon repository",
    branch = "master",
  },
  handofgod = {
    url = "https://github.com/HandOfGod94/AutoVPN",
    desc = "custom handofgod repos",
    branch = "main"
  }
}

spoonInstall:andUse("AutoVPN", { repo = "handofgod", start = true })
```
