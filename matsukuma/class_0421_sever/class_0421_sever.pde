//サーバー
//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Server server;
//サーバ側でクリックした座標
int sx;
//クライアント側でクリックした座標
int cx;
//ポート番号を指定（今回は20000）
int port = 20000;
//ボールの動きを指定するためのやつ
int ball_x, ball_y, div_x, div_y, speed;


//初期化
void setup(){
  //サーバを生成prot番ポートで立ち上げ
  server = new Server(this, port);
  sx = cx = 600;
  ball_x=600;
  ball_y=400;
  div_x=div_y=1;
  speed=6;
  size(1200,800);
  colorMode(HSB, 100);
  background(100);
  smooth();
  rectMode(CENTER);
}

void draw(){
  background(100);
  //クライアントからのデータ取得
  Client c = server.available();
  if(c != null) {
    //改行コード('\n')まで読み込む
    String msg = c.readStringUntil('\n');
    if (msg != null){
      //メッセージを空白で分割して配列に格納
      String[] data = splitTokens(msg);
      //クライアント側のx座標
      cx = int(data[0]);
    }
  }
  rect_draw();
  send_client();
}

void rect_draw(){
  //描画処理
  //相手（クライアント）の描画
  rect(cx,200,300,20);
  //自分（サーバ）の描画
  rect(sx,600,300,20);
  ball();
  ellipse(ball_x, ball_y, 50,50);
}

//ボールの運動を計算するやつ
void ball(){
  
  if(abs(ball_y -200) <= 5 ){
   if( (sx-150) <ball_x && ball_x<(sx +150) ){
     div_y=div_y*(-1);
   }
 }
   if(abs(ball_y -600) <= 5 ){
   if( (cx-150) <ball_x && ball_x<(cx +150) ){
     div_y=div_y*(-1);
   }
 }
  
  if( ball_x>=1180 ){
  div_x=div_x*(-1);
  }
 else if( ball_x<=20 ){
   div_x=div_x*(-1);
 }
 else if( ball_y<=20 ){
   div_y=div_y*(-1);
 }
 else if( ball_y>=780 ){
   div_y=div_y*(-1);
 }
  ball_x=ball_x+div_x*speed;
  ball_y=ball_y+div_y*speed;
}

void send_client(){
  //サーバに送信するメッセージを作成
  //空白で区切り末尾は改行
  String msg = sx + " " +ball_x + " " + ball_y + "\n";
  print("server: " + msg);
  //サーバが接続しているクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

//マウスクリックがクリックされたら
void keyPressed(){
    if( keyCode == LEFT ){
    sx -=40;
    println(LEFT);
    }
    else if( keyCode == RIGHT ){
    sx +=40;
    println(RIGHT);
    }
 }