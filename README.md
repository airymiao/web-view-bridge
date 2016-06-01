#Meow Web View Bridge

iOS & Android webView bridge for sending message based on [marcuswestin/WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)

### Examples

Install [http-server](https://www.npmjs.com/package/http-server),then start front-end server `cd Front-end && http-server -p 8081`

Open either the iOS or Android project,change `urlString` to match local IP address with port like `http://*.*.*.*:8081`.Then run to see the demo


### Usage

#### Front-end

1. Add meow-bridge.js to your project

2. Register bridge handler for app

  ```
  window.webViewBridge.registerHandler("demo-web",function(data,responseCallback){
    responseCallback(data);
    console.log(JSON.stringify(data));
  });
  ```

3. Call bridge method to invoke app matched method

  ```
  window.webViewBridge.callHandler("demo-app", {
    "code": 200,
    "type": "alert",
    "message": {"content": "From front-end!"}
  }, function (responseData) {
    console.log(JSON.stringify(responseData));
  });
  ```

#### iOS

1. Drag the `WebViewJavascriptBridge` folder into your project,or install by CocoaPods(Recommend) 

 ```
  pod 'WebViewJavascriptBridge', '~> 5.0'
 ```
 
2. Initialize bridge

  ```
  UIWebView *webView = [UIWebView alloc] init];
  WebViewJavascriptBridge *javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:webView];
  ```

3. Register bridge handler for front-end

  ```
  [javascriptBridge registerHandler:@"demo-app" handler:^(id data, WVJBResponseCallback responseCallback) {
      NSLog(@"Received data from web:%@",data);
      responseCallback(data);
  }];
  ```

4. Call bridge method to invoke front-end matched method

  ```
  [javascriptBridge callHandler:@"demo-web" data:@{@"code":@"2000",@"type":@"alert",@"message":@{@"content":@"From iOS"}} responseCallback:^(id responseData) {
      NSLog(@"Response data from web:%@",responseData);
  }];
  ```

#### Android

1. Add `meow-bridge-*.*.*.jar` into your project,then import webView client.The source code is in module `Meow-Bridge`.Use gradle task `createJar` to generate jar

  ```
  import com.airymiao.android.meowlib.MeowBridgeWebViewClient;
  ```

2. Initialize bridge

  ```
  WebView bridgeWebView = (WebView) findViewById(R.id.webview);
  MeowBridgeWebViewClient bridgeWebViewClient = new MeowBridgeWebViewClient(bridgeWebView);
  ```

3. Register bridge handler for front-end

  ```
  bridgeWebViewClient.registerHandler("demo-app", new MeowBridgeWebViewClient.WVJBHandler() {
     @Override
     public void request(Object data, MeowBridgeWebViewClient.WVJBResponseCallback callback) {
         Log.v("MeowBridge", "Received data from web:" + data.toString());

         callback.callback(data);
     }
  });
  ```

4. Call bridge method to invoke front-end matched method

  ```
  JSONObject jsonData = new JSONObject();
       try {
           JSONObject messageData = new JSONObject();
           messageData.put("content", "From Android");

           jsonData.put("code", "2000");
           jsonData.put("type", "alert");
           jsonData.put("message", messageData);
       } catch (JSONException e) {
           e.printStackTrace();
       }

  bridgeWebViewClient.callHandler("demo-web", jsonData, new MeowBridgeWebViewClient.WVJBResponseCallback()   {
       @Override
       public void callback(Object data) {
           Log.v("MeowBridge", "Response data from web:" + data.toString());
       }
  });
  ```
