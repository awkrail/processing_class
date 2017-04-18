//大域変数
  //球の座標
  int ball_x, ball_y;
  //長方形の座標
  int rect_x, rect_y;
  //球の方向
  int div_x,div_y;
  //x,y軸の速さ係数
  int speed;

void setup(){
  size(1200,800);
  colorMode(HSB, 100);
  background(100);
  smooth();
   rectMode(CENTER);
  
  //最初の球の位置
  ball_x=600;
  ball_y=400;
  //最初の長方形の位置
  rect_x=600;
  rect_y=600;
  //最初の球の向き
  div_x=div_y=1;
  //速さ係数に代入
  speed=6;
}

void keyPressed(){
    if( keyCode == LEFT ){
    rect_x -=40;
    }
    else if( keyCode == RIGHT ){
    rect_x +=40;
    }
}


void draw(){
  background(100);
  ellipse(ball_x,ball_y,50,50);
 
  ball();
  
  rect(rect_x,rect_y,300,20);
}

//ボールの運動を計算するやつ
void ball(){
  
  if(ball_y== rect_y && div_y==1){
   if( (rect_x-150) <ball_x && ball_x<(rect_x +150) ){
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