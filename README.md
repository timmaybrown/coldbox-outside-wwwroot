# coldbox-outside-wwroot
Skeleton app with Coldbox outside the webroot

Clone the repo then run from the www folder:
``` 
box install --!save
```
The `--!save` flag is to keep the `box.json` from updating the install paths entry to your local absolute file path (which wouldn't make the app very portable) if you forget just change it back to a relative path before committing.

This is just a start, feel free to make some pull requests with changes to the defaults, but really all it takes is a couple mappings in your `Application.cfc` `config/Coldbox.cfc` and in your `config/Wirebox.cfc` just use your `/app` mapping when binding to your models directory via your `mapDirectory(packagePath="app.models");` call.

then run the server start from the `www` folder
```
box server start
```