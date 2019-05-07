#互动课件、教研云课件、题库、答题器通信方式与消息整理

##一、通信方式
###1.1 互动课件与教研云课件
这两种课件都通过嵌入JSSDK，来统一pc与iOS直接的通信。
![](/Users/oyq/Documents/公司文档/工作技术文档/教研云/互动课件信息通信.png)

- 课件->pc端，课件与端的通信经过JSSDK的桥接，课件回调消息到JSSDK，JSSDK再将消息以postMessage的方式回调到PC。

- pc端->课件，PC通过调用JSSDK提供的API，例如翻页API，将数据传递到JSSDK，然后JSSDK再调用课件中的翻页API。

- 老师端->学生端，老师端会跟学生端同步当前课件状态，通过信道将课件回调的data数据发送到学生端。

- 学生端->老师端，同理，学生端端会跟老师端端同步当前课件状态，通过信道将课件回调的data数据发送到学生端。

- 学生端->课件，学生端通过调用JSSDK提供的API，例如翻页API，将数据传递到JSSDK，然后JSSDK再调用课件中的翻页API。

- 课件->学生端，课件与端的通信经过JSSDK的桥接，课件回调消息到JSSDK，JSSDK再将消息以webkit.messageHandlers的方式回调到学生端。

###1.2 题库与答题器
![](/Users/oyq/Documents/公司文档/工作技术文档/教研云/答题器信息通信.png)

- 老师端->学生端，老师端需要与学生端同步开始答题、停止答题、结束答题等信息，通过信道与学生端同步。

- 学生端->老师端，学生端提交答案之后，需要与老师端同步已选择的选项，通过信道与老师端同步。

- 学生端->答题器，学生端直接通过答题器提供的js接口。

- 答题器->学生端，答题器通过webkit.messageHandlers的方式，将学生选择的选项回调到学生端。


## 二、消息整理
###2.1 互动课件信道消息
- 打开课件`openDoc`
- 关闭课件`removeDoc`
- 激活课件`activateDoc`
- 课件翻页`gotoDocPage`
- 课件滚动`scrollPage`
- 更新课件位置`updateDocGeometry`
- 更新音视频课件同步信息`updateAVDocControl`
- 请求同步课件位置`requestStreamGeometry`
- 请求音视频课件进度`requestAVDocProgress`
- 请求同步课件`requestDocSync`
- 发送课件内部消息`docSendMessage`

###2.2 互动课件JSAPI
- JSSDK的回调`setUp`:用户课件加载完成后获取基本参数
- JSSDK的回调`sendMessage`:课件通过消息信道发送信道消息
- JSSDK的回调`sendMessageWithCallback`:课件通过消息信道发送信道消息，并将发送后的回调回送到JSSDK
- JSSDK的回调`BUFFERING_LOAD_ERROR`:课件内部出现错误
- JSSDK的回调`PDF_SCROLLTOP_RESULT`:课件被滚动回调
- JSSDK的回调`PDF_PAGECONTENT_HEIGHT`:课件的高度改变
- JSSDK的API`gotoSlideStep`:课件翻页
- JSSDK的API`scrollTo`:课件滚动
- JSSDK的API`mouse_click`:模拟鼠标点击
- JSSDK发送通用消息API，通过`setUp`时保存的`msg_callback`，再拼装消息的`name`和`body`，直接调用`callBack`

###2.3 教研云课件信道消息
- 打开课件`openDoc`
- 关闭课件`removeDoc`
- 激活课件`activateDoc`
- 请求同步课件`requestDocSync`

老师端与学生端所有的交互都走的信道消息：`docSendMessage`，学生端收到`docSendMessage`消息之后，将`content`字段中的消息发送到课件。

###2.4 教研云课件JSAPI
- JSSDK的回调`setUp`:用户课件加载完成后获取基本参数
- JSSDK的回调`sendMessage`:课件通过消息信道发送信道消息
- JSSDK的回调`sendMessageWithCallback`:课件通过消息信道发送信道消息，并将发送后的回调回送到JSSDK
- JSSDK的回调`DOCQS_SCROLLTOP_RESULT`:课件被滚动回调
- JSSDK的回调`DOCQS_PAGECONTENT_HEIGHT`:课件的高度改变
- JSSDK发送通用消息API，通过`setUp`时保存的`msg_callback`，再拼装消息的`name`和`body`，直接调用`callBack`
- JSSDK的API`gotoSlideStep`:课件翻页
- JSSDK的API`scrollTo`:课件滚动

###2.5 题库信道消息
- 题库打开、关闭、停止、展示答案`onlineTest`

###2.6 题库JSAPI
- JS回调`submitQuestion`:用户提交答案
- JS回调`changeFrame`:题库大小变化

###2.7 答题器信道消息
- 答题器打开、关闭、停止、展示答案`onlineTest`

###2.8 答题器JSAPI
- JS回调`submitQuestion`:用户提交答案
- JS回调`changeFrame`:答题器大小变化
- JSAPI`globalStopTest`:答题器停止答题
- JSAPI`globalStartTest`:答题器开始答题