//クライアント
//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Client client;
//クライアント側でクリックした座標
int cx;
//サーバ側でクリックした座標
int sx;
//サーバのアドレス
//127.0.0.1はローカルマシン
//他のマシンに接続するときは適切に変更
String serverAdder = "127.0.0.1";
//ポート番号を指定（今回は20000）
int port = 20000;
//ボールの動きを指定するためのやつ
int ball_x, ball_y, div_x, div_y, speed;

//初期化
void setup(){
  //指定されたアドレスとポートでサーバに接続
  client = new Client(this, serverAdder, port);
  cx = sx = 600;
  size(1200,800);
  colorMode(HSB, 100);
  background(100);
  smooth();
  rectMode(CENTER);
}

void draw(){
  background(100);
  rect_draw();
}

void rect_draw(){
  //自分（クライアント）の描画
  rect(cx,200,300,20);
  //相手（サーバ）の描画
  rect(sx,600,300,20);
}

//サーバーからデータを受け取るたびに呼び出される関数
void clientEvent(Client c){
  //サーバからのデータ取得
  String msg = c.readStringUntil('\n');
  //メッセージが存在する場合
  if(msg != null){
    //改行を取り除き，空白で分割して配列に格納
    String[] data = splitTokens(msg);
    //サーバ側のx座標
    sx = int(data[0]);
  }
}

//マウスがクリックされたら
void keyPressed(){
  //クライアント側の座標として登録
    if( keyCode == LEFT ){
    cx -=40;
    }
    else if( keyCode == RIGHT ){
    cx +=40;
    }
  //サーバに送るメッセージを作成
  //空白で区切り，末尾に改行を付与
  String msg = cx + " " + "\n";
  print("client: " + msg);
  //クライアントが接続しているメッセージをサーバに送信
  client.write(msg);
}