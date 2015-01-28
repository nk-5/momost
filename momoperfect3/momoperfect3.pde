//ボールの動きの詳細
float FRICTION = 0.98;//減衰率
int Radius = 20; //半径
boolean OnMouse = false; //ボールとマウスポインタの接触フラグ
boolean OnDrag = false;  //ボールのドラッグ中のフラグ
float  X,Y;       //位置
float  X2,Y2;
float Spx, Spy;  //スピード

//敵の反応範囲
  float tekiMinX = 130;  //敵左
  float tekiMaxX = 270; //敵右
  float tekiMinY = 80;    //敵上
  float tekiMaxY = 225; //敵下
  
  PImage momo;
  PImage aka;
  PImage ki;
  PImage ao;
  PImage oni;


//HPの詳細(相手)
int max_teki=400; //HP
int currentHp_teki=4000; //現在のHP、テキスト用
int currentHp_teki2=400;//図形用
int damage_teki = 30; //ダメージ数
float i = 0; //ダメージをどれだけ反映したかを表す
//HPの詳細(自分)
int max=2000; //HP
int currentHp=2000; //現在のHP(最初は最大HPと一緒)
int currentHp2=400; //図形用
int damage = 5; //ダメージ数
float j = 0; //ダメージをどれだけ反映したかを表す

//ターン変数
int turn = 1;

//攻撃変数
float A,B; //物体の位置
float Cx1;//円の中心のX座標
float Cy1;//円の中心のY座標
float Angle1; //円の動きの角度
float R1; //円の動きの半径

float Cx2;//円の中心のX座標
float Cy2;//円の中心のY座標
float Angle2; //円の動きの角度
float R2; //円の動きの半径

float Cx3;//円の中心のX座標
float Cy3;//円の中心のY座標
float Angle3; //円の動きの角度
float R3; //円の動きの半径

float Cx4;//円の中心のX座標
float Cy4;//円の中心のY座標
float Angle4; //円の動きの角度
float R4; //円の動きの半径


void setup(){
  //ボールの動き
  size(400,500);
  momo = loadImage("桃.jpg");
  aka = loadImage("犬.jpg");
  ki = loadImage("猿.jpg");
  ao = loadImage("雉.jpg");
  oni = loadImage("boss.jpg");
  ellipseMode(CENTER);
  colorMode(RGB,100);
  strokeWeight(1);
  frameRate(35);  
  //位置とスピードを初期化
  X = 80;
  Y = 350;
  
  X2 = 160;
  Y2 = 350;
  
  Spx = 0;
  Spy = 0;
  
  //HP詳細
  PFont chara = createFont("HGMinchoE",20); 
  textFont(chara); //この二行で日本語を表示することができます
  textAlign(LEFT); //字を左寄りにする
  //frameRate(50); //1秒に描写する数を設定(HPの減るスピードに影響)
  
    //攻撃
  
  //左
  Cx1= 0;
  Cy1 = 150;
  Angle1 = 0;
  R1 = 200;
  //右
  Cx2 = 400;
  Cy2 = 150;
  Angle2 = 180;
  R2 = 200;
  //上
  Cx3 = 200;
  Cy3 = 0;
  Angle3 = 90; 
  R3 = 150;
  //下
  Cx4 = 200;
  Cy4 = 500;
  Angle4 = 270;
  R4 = 350;
}

void draw(){
  //ボールの動き
  background(255,255,255);
 // translate(width/2,height/2); //(0,0)座標を画面中心にする
  //ドラッグしている時のみ,画面をフェードアウト
 // if(OnDrag)fadeToWhite();
  
  //位置の計算
  if(OnDrag){
      //ドラッグしているときはポインタにボールをつけて動かす
  X = mouseX;
  Y = mouseY;
  X2 = mouseX;
  Y2 = mouseY;
  Spx = mouseX - pmouseX; //マウスの速度をボールの速度に
  Spy = mouseY - pmouseY; 
  }else{
    //ドラッグしていない時は通常の跳ね返り運動
  Spx = Spx * FRICTION;
  Spy = Spy * FRICTION;
  X = X + Spx;
  Y = Y + Spy;
//  X2 = X2 + Spx;
 // Y2 = Y2 + Spy;
  
  //衝突判定
  bounce();
  }
  
  checkOnMouse(); //ボールとマウスが離れているか判定
  
  //描画
 // rect(150,100,100,100);
// if(turn == 1 && turn == 2 && turn == 4 && turn == 5 ){
 if(turn== 1){
  ellipse(X,Y,Radius*2,Radius*2);
 i = X2;
  j = Y2;
    
 ellipse(i,j,Radius*2,Radius*2);
// }
}
if(turn == 2){
 ellipse(X2,Y2,Radius*2,Radius*2);
}
  
  image(momo,0,400,100,100);
  image(aka,200,400,100,100);
  image(ki,100,400,100,100);
  image(ao,300,400,100,100);
   image(oni,150,100,100,100);
   if(turn == 3){
   kougeki();//相手の攻撃ターン
  }
}

void bounce(){//跳ね返り判定
  float bounceMinX = Radius;      //左壁の判定座標
  float bounceMaxX = width - Radius;      //右壁の判定座標
  float bounceMinY = Radius;      //上壁の判定座標
  float bounceMaxY = 375;     //下壁の判定座標
  
  
  //横方向の衝突判定
  if(X < bounceMinX || X > bounceMaxX){
    Spx = -Spx * FRICTION; //スピードを反転して減衰させる
    if(abs(Spx) < 1) Spx = 0; //スピードが小さくなったら止める
    if(X < bounceMinX) X = bounceMinX - (X - bounceMinX);
    if(X > bounceMaxX) X = bounceMaxX - (X - bounceMaxX);
  }
  
  //縦方向の衝突判定
  if(Y < bounceMinY || Y > bounceMaxY){
    Spy = -Spy * FRICTION;
    if(abs(Spy) < 1) Spy = 0;
    if(Y < bounceMinY) Y = bounceMinY - (Y - bounceMinY);
    if(Y > bounceMaxY) Y = bounceMaxY - (Y - bounceMaxY);
  }
  
    //横方向の衝突判定
  if(X2 < bounceMinX || X2 > bounceMaxX){
    Spx = -Spx * FRICTION; //スピードを反転して減衰させる
    if(abs(Spx) < 1) Spx = 0; //スピードが小さくなったら止める
    if(X2 < bounceMinX) X2 = bounceMinX - (X2- bounceMinX);
    if(X2 > bounceMaxX) X2 = bounceMaxX - (X2 - bounceMaxX);
  }
  
  //縦方向の衝突判定
  if(Y2 < bounceMinY || Y2 > bounceMaxY){
    Spy = -Spy * FRICTION;
    if(abs(Spy) < 1) Spy = 0;
    if(Y2 < bounceMinY) Y2 = bounceMinY - (Y2 - bounceMinY);
    if(Y2 > bounceMaxY) Y2 = bounceMaxY - (Y2 - bounceMaxY);
  }
  //相手との横方向の衝突判定
     if(tekiMinX<= X && X <= tekiMaxX && tekiMinY <= Y && Y <= tekiMaxY ){
        Spx = -Spx * FRICTION; //スピードを反転して減衰させる
        X = X + Spx;
           //HP詳細
       //if(i < damage){ //現在のHPをいつまで減らし続けるかの条件式
         //currentHp_teki--; //HP減少
         //i++; //反映したHPを更新
       //}
       if(abs(Spx) < 1){
         Spx = 0;
       }else{
       currentHp_teki2 = currentHp_teki2 - damage;//図形用減少表示
       currentHp_teki = currentHp_teki - (damage*10);//テキスト用減少表示
       if(currentHp_teki <= damage){
         currentHp_teki = 0;//HPが0を割ったら描写を中止させる
        }
       }
    //相手との縦方向の衝突判定    
       if(tekiMinX<= X && X <= tekiMaxX && tekiMinY <= Y && Y <= tekiMaxY ){
            Spx = -Spx * FRICTION; //スピードを反転して減衰させる
            Spy = -Spy * FRICTION;
            if(abs(Spx) < 1) Spx = 0;
            if(abs(Spy) < 1) Spy = 0; 
            X = X + Spx;
    //HP詳細
 /*      if(i < damage){ //現在のHPをいつまで減らし続けるかの条件式
         currentHp_teki--; //HP減少
         i++; //反映したHPを更新
       }
        currentHp_teki = currentHp_teki - damage;
    //     if(currentHp_teki <= 0){
          i = damage; //HPが0を割ったら描写を中止させる
        }
       */
  
       }
   }
   
}

//ボールとマウスが触れているか判定
void checkOnMouse(){
  noFill();
  stroke(90,60,99);
  
  //ボールとマウスが触れているか
  if(turn == 1){
  if(dist(mouseX,mouseY,X,Y) < Radius){
     //ボールとマウスが触れていればフラグをONにして塗りの色をつける
     OnMouse = true;
     fill(90,99,99,30);
  }else{
    //触れていなければフラグをOFFにして色を白に
    OnMouse = false;
    fill(90,0,99,30);
  }
  }
  if(turn == 2){
   //ボールとマウスが触れているか
  if(dist(mouseX,mouseY,X2,Y2) < Radius){
     //ボールとマウスが触れていればフラグをONにして塗りの色をつける
     OnMouse = true;
     fill(90,99,99,30);
  }else{
    //触れていなければフラグをOFFにして色を白に
    OnMouse = false;
    fill(90,0,99,30);
  }
  }


    /*以下はHPバー表示*/    
  //枠(相手)
   noFill();
   strokeWeight(1); //HPバーの枠の太さ
   stroke(0);
   rect(0,0,400,10);
   //枠(自分)
     noFill();
   strokeWeight(1); //HPバーの枠の太さ
   stroke(0);
   rect(0,400,400,10);
   
    //中身(相手)
     fill(0,255,0);
     rect(0,0,currentHp_teki2,10); //現在のHP
      //中身(自分)
     fill(0,255,0);
     rect(0,390,currentHp2,10); //現在のHP
     
     /*HPを数値で表示*/ //(相手)
     fill(0);
     text("/",60,30); //文字には[""]をつける
     text(4000,70,30); //変数にはつけない
     text(currentHp_teki,20,30);
     
        /*HPを数値で表示*/ //(自分)
      fill(0);
     text("/",350,390); //文字には[""]をつける
     text(max,360,390); //変数にはつけない
     text(currentHp,310,390);
     
     //ターン詳細
     fill(0);
     stroke(1);
     text("ターン",330,30); //文字には[""]をつける
     text(turn,390,30); //変数にはつけない
}


void fadeToWhite(){
  noStroke();
  fill(99,30);
  rectMode(CORNER);
  rect(0,0,width,height);
}


void mousePressed(){
 if(turn == 1 || turn == 2 || turn == 4 || turn == 5) {
  if(OnMouse)OnDrag = true;
 }
}


void mouseReleased(){
  OnDrag = false;
    if(turn == 5){
      turn = 1;
    }
  else{
 //   if(turn == 2 && Spx == 0 && Spy == 0){
   //   turn = turn + 1;
  //}
   turn = turn + 1;
  /* if(turn ==1 || turn == 4){  
      turn = turn + 1;
    }
    else if(turn == 2){
    turn = turn + 1;
    }*/
  }
}

void kougeki(){
// frameRate(10);
 //for(int i = 0; i < 50; i++){
     //位置の計算//左
   if(Angle1 < 90){
      A = Cx1+ (R1 * cos(radians(Angle1)));
      B = Cy1+ (R1 * sin(radians(Angle1)));
       //描画
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      ellipse(A,B,10,10);
      ellipse(A + 30,B,10,10);
      ellipse(A - 30,B,10,10);
      Angle1 = Angle1 + 5;
     if(X-10 <= A && A<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
    if(X-10 <= A+30 && A+30 <= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
    if(X-10 <= A - 30 && A - 30<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
  }
  //右
   if(Angle2 < 270){
      A = Cx2 + (R2 * cos(radians(Angle2)));
      B = Cy2 + (R2 * sin(radians(Angle2)));
       //描画
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      ellipse(A,B,10,10);
      ellipse(A + 30,B,10,10);
      ellipse(A - 30,B,10,10);
      Angle2 = Angle2 + 5;
       if(X-10 <= A && A<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
       if(X-10 <= A+30 && A+30 <= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
    if(X-10 <= A - 30 && A - 30<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
  }
  //上
   if(Angle3 < 180){
      A = Cx3 + (R3 * cos(radians(Angle3)));
      B = Cy3 + (R3 * sin(radians(Angle3)));
       //描画
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      ellipse(A,B,10,10);
      ellipse(A + 30,B,10,10);
      ellipse(A - 30,B,10,10);
      Angle3 = Angle3 + 5;
       if(X-10 <= A && A<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
       if(X-10 <= A+30 && A+30 <= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
    if(X-10 <= A - 30 && A - 30<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
  }
  //下
   if(Angle4 < 360){
      A = Cx4 + (R4 * cos(radians(Angle4)));
      B = Cy4 + (R4 * sin(radians(Angle4)));
       //描画
      noStroke();
      fill(0);
      ellipseMode(CENTER);
      ellipse(A,B,10,10);
      ellipse(A + 30,B,10,10);
      ellipse(A - 30,B,10,10);
      Angle4 = Angle4 + 5;
       if(X-10 <= A && A<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
       if(X-10 <= A+30 && A+30 <= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
   }
    if(X-10 <= A - 30 && A - 30<= X + 10&& Y-10 <= B && B <= Y + 10){
    currentHp = currentHp - (damage_teki * 5);
    currentHp2 = currentHp2 - damage_teki;
    }
    }else{
      turn = turn + 1;
      Angle1 = 0;
      Angle2 = 180;
      Angle3 = 90;
      Angle4 = 270; 
    }
    
  
 
}

