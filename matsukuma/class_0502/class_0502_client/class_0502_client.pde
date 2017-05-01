//クライアント
//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Client client;
//クライアント側でクリックした座標
int cx, cy;
//サーバのアドレス
//127.0.0.1はローカルマシン
//他のマシンに接続するときは適切に変更
String serverAdder = "127.0.0.1";
//ポート番号を指定（今回は20000）
int port = 20000;
//ボールの動きを指定するためのやつ
int ball_x, ball_y, div_x, div_y, speed;
//残り回数
int s_left, c_left;

//初期化
void setup(){
  //指定されたアドレスとポートでサーバに接続
  client = new Client(this, serverAdder, port);
  cx = cy = 600;
   ball_x=600;
  ball_y=400;
  div_x=div_y=1;
  speed=6;
  s_left = c_left=10;
  size(1200,800);
  colorMode(HSB, 100);
  background(100);
  smooth();
  rectMode(CENTER);
  noStroke();
}

void draw(){
  background(100);
  rect_draw();
  send_server();
  ball();
  text();
  Break();
}

void rect_draw(){
  //自分（クライアント）の描画
  fill(90);
  rect(600,400, 750,800);
  fill(40);
  rect(cx,cy,150,40);
  ellipse(ball_x,ball_y, 50,50);
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
    s_left = int(data[0]);
  }
}

//ボールの運動を計算するやつ
void ball(){
  if(abs(ball_y -cy) <= 5 ){
   if( (cx-75) <ball_x && ball_x<(cx +75) ){
     div_y=div_y*(-1);
     div_x=div_x*(-1);
     speed=12;
   }
 }
  if( ball_x>=1180 )div_x=div_x*(-1);
 else if( ball_x<=20 )div_x=div_x*(-1);
 else if( ball_y<=20 ){
   div_y=div_y*(-1);
   c_left -= 1;
   speed=6;
 }
 else if( ball_y>=780 ){
   div_y=div_y*(-1);
 }
  ball_x=ball_x+div_x*speed;
  ball_y=ball_y+div_y*speed;
}

void send_server(){
  //サーバに送るメッセージを作成
  //空白で区切り，末尾に改行を付与
  String msg = c_left + " " + "\n";
  print("client: " + msg);
  //クライアントが接続しているメッセージをサーバに送信
  client.write(msg);
}

void keyPressed(){
    if( keyCode == LEFT ) cx -=40;
    else if( keyCode == RIGHT )cx +=40;
    else if( keyCode == UP )cy -=40;
    else if( keyCode == DOWN )cy +=40;
    
    if(cx<=375)cx=375;
    else if(cx>=825)cx=825;
    else if(cy<=40)cy=40;
    else if(cy>=760)cy=760;
 }
 
 void text(){
     fill(0);
     textSize(16);
     text("your left point is..."+ c_left, 10, 35);
     if(c_left<=3){
       textSize(24);
     text("ganbatte!", 10, 60);
     }
     if(s_left<=3){
       textSize(24);
     text("makenaide!", 10, 90);
     }
 }
 
 void Break(){
  if(c_left==0){
    textSize(80);
    text("YOU WIN!", 600, 300);
    delay(2000);
    exit();
  }
  else if(s_left==0){
    textSize(80);
    text("YOU LOSE!", 600, 300);
    delay(2000);
    exit();
  }
}