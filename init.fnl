(local otp (require :otp))

(fn connect-scpt []
  (table.concat ["tell application \"System Events\""
                 "click menu bar item 1 of menu bar 1 of application process \"SystemUIServer\""
                 "click menu item \"%s\" of menu 1 of menu bar item 1 of menu bar 1 of application process \"SystemUIServer\""
                 "delay 3"
                 "set value of text field 1 of window 1 of application process \"UserNotificationCenter\" to \"%s\""
                 "click UI Element \"OK\" of window 1 of application process \"UserNotificationCenter\""
                 "end tell]))"]))

(fn connect [_keys {:title conn-name}]
  (let [totp (otp.new_totp_from_key (hs.settings.get :vpn-auth-token))]
    (print (.. "connecting to " conn-name " with otp " totp))
    (-> (connect-scpt)
        (: :format conn-name (totp:generate))
        (hs.osascript.applescript)
        (match (true _ _)
          (print "Successfully connected to vpn")
          (false _ {:NSLocalizedDescription message})
          (print "failed to connect to vpn. reason: " message)))))

(fn payload->conn-names [payload-content]
  (icollect [_ v (ipairs payload-content)]
    (?. v :UserDefinedName)))

(fn conn-names->menubar-items [conn-names]
  (icollect [_ conn-name (ipairs conn-names)]
    {:title (.. "Connect " conn-name) :fn connect}))

(fn load-vpn-menus []
  (let [vpn-config-file (hs.settings.get :vpn-config-file)
        static-menu [{:title "-"}
                     {:title "Edit Preferences"
                      :menu [{:title "Set .mobileconfig file"
                              :fn set-mobileconfig-file}
                             {:title "Set auth token" :fn set-auth-token}]}]]
    (when (not= nil vpn-config-file)
      (with-open [config-file (io.open vpn-config-file)]
        (-> (config-file:read :*a)
            (string.match "(<plist.*</plist>)")
            (hs.plist.readString)
            (?. :PayloadContent)
            (payload->conn-names)
            (conn-names->menubar-items)
            (hs.fnutils.concat static-menu))))))

(fn set-mobileconfig-file [_keys _menuitem]
  (let [{:1 config-file} (hs.dialog.chooseFileOrFolder "Please select .mobileconfig file")]
    (print (.. "VPN config file " (hs.inspect config-file)))
    (hs.settings.set :vpn-config-file config-file)))

;; TODO: figure out a way to reload once config is set

(fn set-auth-token [_keys _menuitem]
  (let [(_ vpn-auth-token) (hs.dialog.textPrompt "Auth Token"
                                                 "Enter auth token to generate otp from")]
    (print (.. "Auth Token" (hs.inspect vpn-auth-token)))
    (hs.settings.set :vpn-auth-token vpn-auth-token)))

(local menubar (hs.menubar.new))
(fn init []
  (menubar:setTitle :AutoVPN)
  (menubar:setMenu load-vpn-menus))

(fn start []
  (menubar:setMenu load-vpn-menus))

{: init : start .name :AutoVPN}
