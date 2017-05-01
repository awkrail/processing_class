//サーバー
//ソケット通信のためのライブラリを読み込み
import processing.net.*;
Server server;
//サーバ側でクリックした座標
int sx, sy;
//ポート番号を指定（今回は20000）
int port = 20000;
//ボールの動きを指定するためのやつ
int ball_x, ball_y, div_x, div_y, speed;
//残り回数
int s_left, c_left;


//初期化
void setup(){
  //サーバを生成prot番ポートで立ち上げ
  server = new Server(this, port);
  sx = 600;
  sy = 600;
  ball_x=600;
  ball_y=400;
  div_x=div_y=1;
  speed=6;
  s_left= c_left =10;
  size(1200,800);
  colorMode(HSB, 100);
  background(100);
  smooth();
  rectMode(CENTER);
  noStroke();
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
     c_left = int(data[0]);
    }
  }
  ball();
  rect_draw();
  send_client();
  pushMatrix();
    text();
  popMatrix();
  Break();
}

void Break(){
  if(s_left==0){
    textSize(80);
    text("YOU WIN!", 600, 300);
    delay(4000);
    exit();
  }
  else if(c_left==0){
    textSize(80);
    text("YOU LOSE!", 600, 300);
    delay(2000);
    exit();
  }
}

void rect_draw(){
  //自分（サーバ）の描画
  fill(90);
  rect(600,400, 750,800);
  fill(40);
  rect(sx,sy,150,40);
  ellipse(ball_x, ball_y, 50,50);
}

//ボールの運動を計算するやつ
void ball(){
  if(abs(ball_y -sy) <= 5 ){
   if( (sx-75) <ball_x && ball_x<(sx +75) ){
     div_y=div_y*(-1);
     div_x=div_x*(-1);
     speed=12;
   }
 }
  if( ball_x>=1180 ){div_x=div_x*(-1);}
 else if( ball_x<=20 ){div_x=div_x*(-1);}
 else if( ball_y<=20 ){
   div_y=div_y*(-1);
   s_left -= 1;
   speed=6;
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
  String msg = s_left+ "\n";
  print("server: " + msg);
  //サーバが接続しているクライアントに送信
  //(複数のクライアントが接続している場合は全てのクライアントに送信)
  server.write(msg);
}

//マウスクリックがクリックされたら
void keyPressed(){
    if( keyCode == LEFT ) sx -=40;
    else if( keyCode == RIGHT )sx +=40;
    else if( keyCode == UP )sy -=40;
    else if( keyCode == DOWN )sy +=40;
    
    if(sx<=375)sx=375;
    else if(sx>=825)sx=825;
    else if(sy<=40)sy=40;
    else if(sy>=760)sy=760;
 }
 
 void text(){
     fill(0);
     textSize(16);
     text("your left point is..."+ s_left, 10, 35);
     if(s_left<=3){
       textSize(24);
     text("ganbatte!", 10, 60);
     }
     else if(c_left<=3){
       textSize(24);
     text("makeruna!", 10, 90);
     }
 }