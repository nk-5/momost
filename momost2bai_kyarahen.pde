import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer bgm;
AudioPlayer kouka;
AudioPlayer cure1;
AudioPlayer magic_up1;
AudioPlayer reflection1;
AudioPlayer enemy_oto;


//ボールの動きの詳細
float FRICTION = 0.95;//減衰率
int Radius = 40; //半径2
boolean OnMouse = false; //ボールとマウスポインタの接触フラグ
boolean OnDrag = false;  //ボールのドラッグ中のフラグ
boolean flag = false;

float X, Y;         //１つ目のボール位置
float X2, Y2;       //２つ目のボール位置
float X3, Y3;       //３つ目のボール位置
float X4, Y4;       //４つ目のボール位置

float Spx, Spy;  //スピード1
float Spx2, Spy2;  //スピード2
float Spx3, Spy3;  //スピード3
float Spx4, Spy4;  //スピード4

int time = 0; //ターン

boolean turn1 = false;//ボール1のターンの終了フラグ
boolean turn2 = false;//ボール2のターンの終了フラグ
boolean turn3 = false;//ボール3のターンの終了フラグ
boolean turn4 = false;//ボール4のターンの終了フラグ

boolean inu_flag = false;//犬を動かすときすでに桃太郎の位置にあるときTrueにする
boolean kiji_flag = false;//雉を動かすときすでに桃太郎の位置にあるときTrueにする

int flag2 = 0;//
int EOF = 0;//終了条件

//敵の反応範囲
float tekiMinX = 260;  //敵左2
float tekiMaxX = 540; //敵右2
float tekiMinY = 160;    //敵上2
float tekiMaxY = 450; //敵下2

//画像の宣言 
PImage momo;
PImage aka;
PImage ki;
PImage ao;
PImage oni;
PImage oni2;
PImage oni3;
PImage kabe;
PImage dango;
PImage lose;
PImage fire;

int syutugen;//団子の出現頻度変数
float itiX;//団子の座標
float itiY;

//HPの詳細(相手)
int max_teki=800; //HP2
int currentHp_teki=4000; //現在のHP、テキスト用
int currentHp_teki2=800;//図形用2
float damage_teki = 100; //ダメージ数
float i = 0; //ダメージをどれだけ反映したかを表す

//HPの詳細(自分)
int max=2000; //HP
float currentHp=2000; //現在のHP(最初は最大HPと一緒)
float currentHp2=800; //図形用2
int damage = 10; //ダメージ数
int kaifuku = 250;//回復数
float j = 0; //ダメージをどれだけ反映したかを表す

//相手ターン変数
int enemyturn = 3;

//攻撃変数
float A, B; //物体の位置
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

//バリア変数（lineにいれる変数）
float baria_x = 320;//2
float baria_y = 700;//2

//攻撃力アップ変数
float attack_up = 1.25;
boolean attack_flag = false;

//回復力アップ変数
float ceal_up = 1.25;
boolean ceal_flag = false;


void setup() {
  size(800, 1000);//2
  //画像の表示
  kabe = loadImage("haikei2.jpg");
  momo = loadImage("momo.jpg");
  aka = loadImage("inu.jpg");
  ki = loadImage("saru.jpg");
  ao = loadImage("kiji.jpg");
  oni = loadImage("boss.jpg");
  oni2 = loadImage("boss2.jpg");
  oni3 = loadImage("boss3.jpg");
  dango  = loadImage("dango.jpg");
  lose = loadImage("lose.JPG");
  fire = loadImage("炎.jpg");

  //音楽の指定
  minim = new Minim(this);
  bgm = minim.loadFile("battle2.mp3");
  kouka =minim.loadFile("oto1.mp3");//攻撃音
  cure1 =minim.loadFile("cure.mp3");//回復音
  magic_up1 =minim.loadFile("magic-up.mp3");//攻撃アップ音
  reflection1 =minim.loadFile("reflection.mp3");//バリア音
  enemy_oto =minim.loadFile("enemy_kouka.mp3");//敵の効果音

  ellipseMode(CENTER);
  colorMode(RGB);
  strokeWeight(1);
  frameRate(35);  
  bgm.loop();


  //位置のスピードを初期化
  //➀  
  X = 160;//2
  Y = 700;//2
  Spx = 0;
  Spy = 0;
  //➁
  X2 = 320;//2
  Y2 = 700;//2  
  Spx2 = 0;
  Spy2 = 0;
  //➂
  X3 = 480;//2
  Y3 = 700;//2  
  Spx3 = 0;
  Spy3 = 0;
  //➃
  X4 = 640;//2
  Y4 = 700;//2  
  Spx4 = 0;
  Spy4 = 0; 

  //HP詳細
  PFont chara = createFont("HGMinchoE", 20); 
  textFont(chara); 
  textAlign(LEFT); //字を左寄りにする

  //攻撃変数
  //左
  Cx1= 0;
  Cy1 = 300;//2
  Angle1 = 0;
  R1 = 400;//2
  //右
  Cx2 = 400;//2
  Cy2 = 0;
  Angle2 = 90;
  R2 = 300;//2
  //上
  Cx3 = 400;//2
  Cy3 = 0;
  Angle3 = 90; 
  R3 = 300;//2
  //下
  Cx4 = 800;//2
  Cy4 = 300;//2
  Angle4 = 180;
  R4 = 400;//2
}

void draw() {

  //---------ボール１の位置の計算---------------------
  if (time == 0) {
    if (OnDrag) {   //ドラッグしているときはポインタにボールをつけて動かす
      X = mouseX;
      Y = mouseY;
      Spx = mouseX - pmouseX; //マウスの速度をボールの速度に
      Spy = mouseY - pmouseY;
    }
    else {
      //ドラッグしていない時は通常の跳ね返り運動
      Spx = Spx * FRICTION;
      Spy = Spy * FRICTION;
      X = X + Spx;
      Y = Y + Spy;

      if (abs(Spx) < 2 && abs(Spy) < 2) {  //スピードが落ちたら止める
        Spx = 0;
        Spy = 0;
      }

      //衝突判定
      bounce();
    }
    
    //桃太郎が犬もしくは雉の位置になったらフラグをTrueにする
    if (X >= (X3-40) && X <= (X3 + 60)  &&  Y >= (Y3-40) && Y <= (Y3 + 60)) {//2
      inu_flag = true;
    }
    if (X >= (X4-40) && X <= (X4 + 60)  &&  Y >= (Y4-40) && Y <= (Y4 + 60)) {//2
      kiji_flag = true;
    }
   
    //ターンの終了条件
    if (Spx == 0 && Spy == 0 && turn1 == true && X != 160) {//Xの値は2倍にできている
      turn1 = false;
      baria_x = X2;
      baria_y = Y2;
      attack_up = 1.25;
      if (damage != 10) {
        damage = 10;
      } 
      time = time + 1;
      if (enemyturn != 0) {
        enemyturn = enemyturn - 1;
      }
    }
  }
  //----------------------------------------------------------

  //----------------ボール２の位置の計算----------------------
  if (time == 1) {
    if (OnDrag) {
      //ドラッグしているときはポインタにボールをつけて動かす
      //一つ目のボールを動かす    
      X2 = mouseX;
      Y2 = mouseY;
      Spx2 = mouseX - pmouseX; //マウスの速度をボールの速度に
      Spy2 = mouseY - pmouseY;
    }
    else {
      //ドラッグしていない時は通常の跳ね返り運動
      Spx2 = Spx2 * FRICTION;
      Spy2 = Spy2 * FRICTION;
      X2 = X2 + Spx2;
      Y2 = Y2 + Spy2;

      if (abs(Spx2) < 2) {//スピードが落ちたら止める
        Spx2 = 0;
      }
      if (abs(Spy2) < 2) {
        Spy2 = 0;
      }

      //衝突判定
      bounce();
    }
    if (Spx2 == 0 && Spy2 == 0 && turn2 == true && X2 != 320) {//X2の値は2倍にできている
      reflection1.rewind();
      reflection1.play();
      time = time + 1;
      turn2 = false;
      if (enemyturn != 0) {
        enemyturn = enemyturn - 1;
      }
    }
  }
  //---------------------------------------------------------

  //---------------ボール3の位置の計算-----------------------
  if (time == 2) {
    if (OnDrag) {
      //ドラッグしているときはポインタにボールをつけて動かす
      //一つ目のボールを動かす    
      X3 = mouseX;
      Y3 = mouseY;
      Spx3 = mouseX - pmouseX; //マウスの速度をボールの速度に
      Spy3 = mouseY - pmouseY;
      inu_flag = false;
    }
    else {
      //ドラッグしていない時は通常の跳ね返り運動
      Spx3 = Spx3 * FRICTION;
      Spy3 = Spy3 * FRICTION;
      X3 = X3 + Spx3;
      Y3 = Y3 + Spy3;

      if (X >= (X3-40) && X <= (X3 + 60)  &&  Y >= (Y3-40) && Y <= (Y3 + 60) && time == 2 && inu_flag == false) {//2
        magic_up1.rewind();
        magic_up1.play();
        attack_flag = true;//テキストの表示ON
        damage = damage + round(attack_up);
        Spx3 = 0;
        Spy3 = 0;
      }
      if (abs(Spx3) < 2 && abs(Spy3) < 2) {//スピードが落ちたら止める
        Spx3 = 0;
        Spy3 = 0;
      }

      //衝突判定
      bounce();
    }
    if (Spx3 == 0 && Spy3 == 0 && turn3 == true && X3 != 480) {//X3の値は2倍にできている
      time = time + 1;
      turn3 = false;
      if (enemyturn != 0) {
        enemyturn = enemyturn - 1;
      }
    }
  }
  //----------------------------------------------------------- 

  //---------------ボール4の位置の計算-----------------------
  if (time == 3) {
    if (OnDrag) {
      //ドラッグしているときはポインタにボールをつけて動かす
      //一つ目のボールを動かす    
      X4 = mouseX;
      Y4 = mouseY;
      Spx4 = mouseX - pmouseX; //マウスの速度をボールの速度に
      Spy4 = mouseY - pmouseY;
      kiji_flag = false;
    }
    else {
      //ドラッグしていない時は通常の跳ね返り運動
      Spx4 = Spx4 * FRICTION;
      Spy4 = Spy4 * FRICTION;
      X4 = X4 + Spx4;
      Y4 = Y4 + Spy4;

      if (X >= (X4-40) && X <= (X4 + 60)  &&  Y >= (Y4-40) && Y <= (Y4 + 60) && time == 3 && kiji_flag == false) {//2
        cure1.rewind();
        cure1.play();
        ceal_flag = true;//テキストの表示ON
        currentHp = currentHp + round(ceal_up); 
        currentHp2 = currentHp2 + (round(ceal_up) / 5); 
        Spx4 = 0;
        Spy4 = 0;
        if (currentHp > 2000  || currentHp2 > 800) {
          currentHp = 2000;
          currentHp2 = 800;
        }
      }

      if (abs(Spx4) < 2 && abs(Spy4) < 2) {//スピードが落ちたら止める
        Spx4 = 0;
        Spy4 = 0;
      }
      
      //衝突判定
      bounce();
    }
    if (Spx4 == 0 && Spy4 == 0 && turn4 == true && X4 != 640) {//X4の値は2倍にできている
      time = 0;
      turn4 = false;
      if (enemyturn != 0) {
        enemyturn = enemyturn - 1;
      }
    }
  }
  //----------------------------------------------------------- 

  checkOnMouse(); //ボールとマウスが離れているか判定

  //描画
  noTint();
    image(kabe, 0, 0, 800, 1000);

  //--------ボール1------------
  fill(255, 20, 147);
  strokeWeight(1);
  ellipse(X, Y, Radius*2, Radius*2);
  fill(0, 0, 0);
  textSize(30);
  text("桃", X-15, Y+5);
  //--------ボール2------------
  fill(255, 255, 0);
  ellipse(X2, Y2, 60, 60);
  fill(0, 0, 0);
  textSize(30);
  text("猿", X2-15, Y2+5);
  //--------ボール3------------
  fill(255, 0, 0);
  ellipse(X3, Y3,60, 60);
  fill(0, 0, 0);
  textSize(30);
  text("犬", X3-15, Y3+5);
  //--------ボール4------------
  fill(0, 0, 255);
  ellipse(X4, Y4, 60, 60);
  fill(0, 0, 0);
  textSize(30);
  text("雉", X4-15, Y4+5);


  //-----------キャラクター表示------------
  //------------桃太郎------------2
  if (time == 0) {
    tint(255, 20, 147);
    image(momo, 0, 800, 200, 200);
    noTint();
    image(ki, 200, 800, 200, 200);  
    image(aka, 400, 800, 200, 200); 
    image(ao, 600, 800, 200, 200);   
  }
  //------------猿------------2
  
  if (time == 1) {
    tint(255,255,0);
    image(ki, 200, 800, 200, 200);
    noTint();
    image(momo, 0, 800, 200, 200);
    image(aka, 400, 800, 200, 200); 
    image(ao, 600, 800, 200, 200); 
  }
   //------------犬------------2
 
  if (time == 2) {
    tint(255, 0, 0);
    image(aka, 400, 800, 200, 200);  
    noTint();
    image(momo, 0, 800, 200, 200);
    image(ki, 200, 800, 200, 200);  
    image(ao, 600, 800, 200, 200);
  }
  //------------雉------------2
  if (time == 3) {
    tint(31,127,255);
    image(ao, 600, 800, 200, 200);
    noTint();
    image(momo, 0, 800, 200, 200);
    image(ki, 200, 800, 200, 200); 
    image(aka, 400, 800, 200, 200); 
  }

  //ボスの変化
  if (currentHp_teki <= 2000) {
    noTint();
    image(oni, 300, 200, 200, 200);//2
  }
  if (currentHp_teki > 2000) {
    noTint();
    image(oni2, 300, 200, 200, 200);//2
  }
  
  strokeWeight(3);
    line(200,800,200,1000);
    line(400,800,400,1000);
    line(600,800,600,1000);

  //団子の表示2
  if (syutugen == 4) {
    itiX = random(1, 740);
    itiY = random(80, 600);
    if (itiX > 240 && itiX < 500 && itiY > 140 && itiY < 400) {
      itiX = random(1, 740);
      itiY = random(80, 600);
    }
    syutugen = syutugen + 1;
  }
  if (X >= itiX && X <= (itiX +50)  &&  Y >= itiY && Y <= (itiY + 50)) {
    currentHp = currentHp + kaifuku; 
    currentHp2 = currentHp2 + (kaifuku / 5); 
    itiX = 2000;//2
    itiY = 2000;//2
    if (currentHp > 2000  || currentHp2 > 800) {//2
      currentHp = 2000;
      currentHp2 = 800;
    }
    syutugen = 1;
  }
  if (syutugen != 1) {
    if (syutugen > 4) {
      if (itiX != 0 && itiY != 0) {
        image(dango, itiX, itiY, 60, 60);//2
      }
    }
  } 
  /*以下はHPバー表示*/
  //枠(相手)
  noFill();
  strokeWeight(1); //HPバーの枠の太さ
  stroke(0);
  rect(0, 0, 800, 20);//2
  //枠(自分)
  noFill();
  strokeWeight(1); //HPバーの枠の太さ
  stroke(0);
  rect(0, 780, 800, 20);//2

  //中身(相手)
  fill(0, 255, 0);
  rect(0, 0, currentHp_teki2, 20); //現在のHP2
  //中身(自分)
  fill(0, 255, 0);
  rect(0, 780, currentHp2, 20); //現在のHP2

  /*HPを数値で表示*/  //(相手)
  textSize(40);
  fill(255, 255, 255);
  text("/", 160, 60);//2 
  text(4000, 200, 60);//2
  text(currentHp_teki, 40, 60);//2

  /*HPを数値で表示*/  //(自分)
  fill(255, 255, 255);
  text("/", 660, 780);//2
  text(max, 700, 780);//2
  text(round(currentHp), 540, 780);//2

  //バリア詳細
  stroke(255, 255, 0);
  strokeWeight(5);
  line(baria_x, baria_y, X2, Y2);

  //攻撃力詳細
  if(ceal_flag == false && attack_flag ==false){
    fill(255);
    textSize(20);
    text("攻撃力アップ値", 565, 100);//2
    fill(255, 0, 0);
    textSize(30);
    text(attack_up, 700, 100);//2
  } 
  
  if(attack_flag == true){
    fill(255);
    textSize(30);
    text("攻撃力", 520, 70);//2
    fill(255, 0, 0);
    textSize(40);
    text(attack_up, 590, 70);//2
    textSize(30);
    fill(255);
    text("アップ",710,70);
  }
  if (mouseX > (X4-10) && mouseX < (X4+10) && mouseY > (Y4-10) && mouseY < (Y4+10)) {
    attack_flag = false;
    attack_up = 1.25;
  }



  //回復力詳細
  if(ceal_flag == false && attack_flag ==false){
    fill(255);
    textSize(20);
    text("回復アップ値", 565, 70);//2
    fill(0, 255, 0);
    textSize(30);
    text(ceal_up, 700, 70);//2
  } 
  if(ceal_flag == true){
    fill(255);
    textSize(30);
    text("ＨＰ", 540, 70);//2
    fill(0, 255, 0);
    textSize(40);
    text(ceal_up, 590, 70);//2
    fill(255);
    textSize(30);
    text("回復",730,70);
  }
  if (mouseX > (X-10) && mouseX < (X+10) && mouseY > (Y-10) && mouseY < (Y+10)) {
    ceal_flag = false;
    ceal_up = 1.25;
  }


  //ターン詳細
  fill(255, 255, 255);
  stroke(1);
 /* textSize(40);
  text("相手ターンまで", 480, 60); //2*/
  if(enemyturn == 3){
   fill(0,255,0);
   textSize(40);
   text(enemyturn, 470, 240); //2
  }
 if(enemyturn == 2){
   fill(0,0,255);
   textSize(40);
   text(enemyturn, 470, 240); //2
  }
 if(enemyturn == 1){
   fill(255,0,0);
   textSize(40);
   text(enemyturn, 470, 240); //2
  }

  if (enemyturn == 0) {
    kougeki();//相手の攻撃ターン
  }

  if (currentHp_teki == 0 || currentHp ==0) {
    Stop();
  }
}

void bounce() {//跳ね返り判定
  float bounceMinX = Radius;      //左壁の判定座標
  float bounceMaxX = width - Radius;      //右壁の判定座標
  float bounceMinY = Radius;      //上壁の判定座標
  float bounceMaxY = 750;     //下壁の判定座標//2

  //----------------ボール1--------------------- 
  //横方向の衝突判定1
  if (X < bounceMinX || X > bounceMaxX) {
    Spx = -Spx * FRICTION; //スピードを反転して減衰させる
    if (abs(Spx) < 1) Spx = 0; //スピードが小さくなったら止める
    if (X < bounceMinX) X = bounceMinX - (X - bounceMinX);
    if (X > bounceMaxX) X = bounceMaxX - (X - bounceMaxX);
  }

  //縦方向の衝突判定1
  if (Y < bounceMinY || Y > bounceMaxY) {
    Spy = -Spy * FRICTION;
    if (abs(Spy) < 1) Spy = 0;
    if (Y < bounceMinY) Y = bounceMinY - (Y - bounceMinY);
    if (Y > bounceMaxY) Y = bounceMaxY - (Y - bounceMaxY);
  }

  //----------------ボール2---------------------   
  //縦方向の衝突判定2
  if (Y2 < bounceMinY || Y2 > bounceMaxY || Y2-10 == tekiMinY || Y2 + 10 == tekiMaxY) {
    Spy2 = 0;
    Spx2 = 0;
    if (Y2 < bounceMinY) Y2 = bounceMinY;
    if (Y2 > bounceMaxY) Y2 = bounceMaxY;
    if(Y2 - 10 == tekiMinY) Y2 = tekiMinY;  
    if(Y2 + 10 == tekiMaxY) Y2 = tekiMaxY;
  }
  //横方向の衝突判定2
  if (X2 < bounceMinX || X2 > bounceMaxX || X2 - 10 == tekiMinX || X2+10 == tekiMaxX) {
    Spx2 = 0;
    Spy2 = 0;
    if (X2 < bounceMinX) X2 = bounceMinX;
    if (X2 > bounceMaxX) X2 = bounceMaxX;
    if(X2-10 == tekiMinX) X2 = tekiMinX;
    if(X2+10 == tekiMaxX) X2 = tekiMaxX;   
  }

  //----------------ボール3---------------------   
  //縦方向の衝突判定3
  if (Y3 < bounceMinY || Y3 > bounceMaxY) {
    if (attack_up < 500) {
      attack_up = attack_up * 1.25;//壁に当たれば当たるほど攻撃力アップ
    }
    Spy3 = -Spy3 * FRICTION;
    if (abs(Spy3) < 1) Spy3 = 0;
    if (Y3 < bounceMinY) Y3 = bounceMinY - (Y3 - bounceMinY);
    if (Y3 > bounceMaxY) Y3 = bounceMaxY - (Y3 - bounceMaxY);
  }
  //横方向の衝突判定3
  if (X3 < bounceMinX || X3 > bounceMaxX) {
    if (attack_up < 500) {
      attack_up = attack_up * 1.25;
    }
    Spx3 = -Spx3 * FRICTION; //スピードを判定して減衰させる
    if (abs(Spx3) < 1) Spx3 = 0; //スピードが小さくなったら止める
    if (X3 < bounceMinX) X3 = bounceMinX - (X3 - bounceMinX);
    if (X3 > bounceMaxX) X3 = bounceMaxX - (X3 - bounceMaxX);
  }
  //----------------ボール4--------------------- 
  //縦方向の衝突判定4
  if (Y4 < bounceMinY || Y4 > bounceMaxY) {
    ceal_up = ceal_up * 1.25;  //壁に当たれば当たるほど回復力アップ
    Spy4 = -Spy4 * FRICTION;
    if (abs(Spy4) < 1) Spy4 = 0;
    if (Y4 < bounceMinY) Y4 = bounceMinY - (Y4 - bounceMinY);
    if (Y4 > bounceMaxY) Y4 = bounceMaxY - (Y4 - bounceMaxY);
  }
  //横方向の衝突判定4
  if (X4 < bounceMinX || X4 > bounceMaxX) {
    ceal_up = ceal_up * 1.25;  //壁に当たれば当たるほど回復力アップ
    Spx4 = -Spx4 * FRICTION; //スピードを判定して減衰させる
    if (abs(Spx4) < 1) Spx4 = 0; //スピードが小さくなったら止める
    if (X4 < bounceMinX) X4 = bounceMinX - (X4 - bounceMinX);
    if (X4 > bounceMaxX) X4 = bounceMaxX - (X4 - bounceMaxX);
  }

  //--------------------相手との横方向の衝突判定1---------------------------
  if (tekiMinX<= X && X <= tekiMaxX && tekiMinY <= Y && Y <= tekiMaxY ) {
    kouka.rewind();
    kouka.play();

    Spx = -Spx * FRICTION; //スピードを反転して減衰させる
    X = X + Spx;
    //HP詳細
    if (abs(Spx) < 1) {
      Spx = 0;
    }
    else {
      currentHp_teki2 = currentHp_teki2 - (damage+((round(attack_up)-1)/5));//図形用減少表示
      currentHp_teki = currentHp_teki - ((damage*5)+(round(attack_up)-1));  //テキスト用減少表示

      if (currentHp_teki <= damage) {
        currentHp_teki = 0;//HPが0を割ったら描写を中止させる
        Stop();
      }
    }
  }

  //相手との縦方向の衝突判定1   
  if (tekiMinX<= X && X <= tekiMaxX && tekiMinY <= Y && Y <= tekiMaxY ) {
    kouka.rewind();
    
    kouka.play();
    Spx = -Spx * FRICTION; //スピードを反転して減衰させる
    Spy = -Spy * FRICTION;
    if (abs(Spx) < 1) Spx = 0;
    if (abs(Spy) < 1) Spy = 0; 
    X = X + Spx;
  }
  //---------------------------------------------------------------------------

  //--------------------相手との横方向の衝突判定2----------------------------
  if (tekiMinX<= X2 && X2 <= tekiMaxX && tekiMinY <= Y2 && Y2 <= tekiMaxY ) {        
    Spx2 = -Spx2 * FRICTION; //スピードを反転して減衰させる
    X2 = X2 + Spx2;
    //HP詳細
    if (abs(Spx2) < 1) {
      Spx2 = 0;
    }
    else {
      if (currentHp_teki <= damage) {
        currentHp_teki = 0;//HPが0を割ったら描写を中止させる
        Stop();
      }
    }
  }

  //相手との縦方向の衝突判定1   
  if (tekiMinX<= X2 && X2 <= tekiMaxX && tekiMinY <= Y2 && Y2 <= tekiMaxY ) {
    Spx2 = -Spx2 * FRICTION; //スピードを反転して減衰させる
    Spy2 = -Spy2 * FRICTION;
    if (abs(Spx2) < 1) Spx2 = 0;
    if (abs(Spy2) < 1) Spy2 = 0; 
    X2 = X2 + Spx2;
  }
  //------------------------------------------------------------------------------

  //--------------------相手との横方向の衝突判定3----------------------------
  if (tekiMinX<= X3 && X3 <= tekiMaxX && tekiMinY <= Y3 && Y3 <= tekiMaxY ) {        
    Spx3 = -Spx3 * FRICTION; //スピードを反転して減衰させる
    X3 = X3 + Spx3;
    //HP詳細
    if (abs(Spx3) < 1) {
      Spx3 = 0;
    }
    else {
      if (currentHp_teki <= damage) {
        currentHp_teki = 0;//HPが0を割ったら描写を中止させる
        Stop();
      }
    }
  }

  //相手との縦方向の衝突判定3   
  if (tekiMinX<= X3 && X3 <= tekiMaxX && tekiMinY <= Y3 && Y3 <= tekiMaxY ) {
    Spx3 = -Spx3 * FRICTION; //スピードを反転して減衰させる
    Spy3 = -Spy3 * FRICTION;
    if (abs(Spx3) < 1) Spx3 = 0;
    if (abs(Spy3) < 1) Spy3 = 0; 
    X3 = X3 + Spx3;
  }
  //------------------------------------------------------------------------------
  //--------------------相手との横方向の衝突判定4----------------------------
  if (tekiMinX<= X4 && X4 <= tekiMaxX && tekiMinY <= Y4 && Y4 <= tekiMaxY ) {        
    Spx4 = -Spx4 * FRICTION; //スピードを反転して減衰させる
    X4 = X4 + Spx4;
    //HP詳細
    if (abs(Spx4) < 1) {
      Spx4 = 0;
    }
    else {
      if (currentHp_teki <= damage) {
        currentHp_teki = 0;//HPが0を割ったら描写を中止させる
        Stop();
      }
    }
  }

  //相手との縦方向の衝突判定4   
  if (tekiMinX<= X4 && X4 <= tekiMaxX && tekiMinY <= Y4 && Y4 <= tekiMaxY ) {
    Spx4 = -Spx4 * FRICTION; //スピードを反転して減衰させる
    Spy4 = -Spy4 * FRICTION;
    if (abs(Spx4) < 1) Spx4 = 0;
    if (abs(Spy4) < 1) Spy4 = 0; 
    X4 = X4 + Spx4;
  }
  //------------------------------------------------------------------------------
}

//ボールとマウスが触れているか判定
void checkOnMouse() {
  noFill();  
  //ボールとマウスが触れているか
  if (enemyturn != 0) {    
    if (time == 0) {
      if (dist(mouseX, mouseY, X, Y) < Radius) {
        //ボールとマウスが触れていればフラグをONにして塗りの色をつける
        OnMouse = true;
        fill(255, 105, 180);
      }
      else {
        //触れていなければフラグをOFFにして色を白に
        OnMouse = false;
        fill(255, 105, 180);
      }
    }
    if (time == 1) {
      if (dist(mouseX, mouseY, X2, Y2) < Radius) {
        //ボールとマウスが触れていればフラグをONにしてnuriの色をつける
        OnMouse = true;
        fill(90, 99, 99, 30);
      }
      else {
        //触れていなければフラグをOFFにして色を白に
        OnMouse = false;
        fill(90, 0, 99, 30);
      }
    }
    if (time == 2) {
      if (dist(mouseX, mouseY, X3, Y3) < Radius) {
        //ボールとマウスが触れていればフラグをONにしてnuriの色をつける
        OnMouse = true;
        fill(90, 99, 99, 30);
      }
      else {
        //触れていなければフラグをOFFにして色を白に
        OnMouse = false;
        fill(90, 0, 99, 30);
      }
    }
    if (time == 3) {
      if (dist(mouseX, mouseY, X4, Y4) < Radius) {
        //ボールとマウスが触れていればフラグをONにしてnuriの色をつける
        OnMouse = true;
        fill(90, 99, 99, 30);
      }
      else {
        //触れていなければフラグをOFFにして色を白に
        OnMouse = false;
        fill(90, 0, 99, 30);
      }
    }
  }
}

void mousePressed() {
  //-----------ボール1----------------
  if (time == 0) {
    if (mouseX > (X-20) && mouseX < (X+20) && mouseY > (Y-20) && mouseY < (Y+20)) {
      if (OnMouse)OnDrag = true;
    }
  }
  if (time == 1) {
    if (mouseX > (X2-20) && mouseX < (X2+20) && mouseY > (Y2-20) && mouseY < (Y2+20)) {
      if (OnMouse)OnDrag = true;
    }
  }
  if (time == 2) {
    if (mouseX > (X3-20) && mouseX < (X3+20) && mouseY > (Y3-20) && mouseY < (Y3+20)) {
      if (OnMouse)OnDrag = true;
    }
  }
  if (time == 3) {
    if (mouseX > (X4-20) && mouseX < (X4+20) && mouseY > (Y4-20) && mouseY < (Y4+20)) {
      if (OnMouse)OnDrag = true;
    }
  }
}


void mouseReleased() {
  OnDrag = false;
  if (time == 0) {
    if (Spx != 0 && Spy != 0) {  //
      turn1 = true;
    }
  }
  if (time == 1) {
    if (Spx2 != 0 && Spy2 != 0) {
      turn2 = true;
      syutugen = syutugen + 1;
    }
  }
  if (time == 2) {
    if (Spx3 != 0 && Spy3 != 0) {
      turn3 = true;
    }
  }
  if (time == 3) {
    if (Spx4 != 0 && Spy4 != 0) {
      turn4 = true;
      syutugen = syutugen + 1;
    }
  }
} 
//相手の攻撃
void kougeki() {
  delay(70);
  if (currentHp <= damage_teki) {
    currentHp = 0;//HPが0を割ったら中止させる
    Stop();
  }
  if (currentHp_teki < 2000) {
    damage_teki = 200;
  }

  //位置の計算  左
  if (Angle1 < 90) {
    A = Cx1+ (R1 * cos(radians(Angle1)));
    B = Cy1+ (R1 * sin(radians(Angle1)));
    //描画
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(A, B, 20, 20);
    ellipse(A + 30, B, 20, 20);
    ellipse(A - 30, B, 20, 20);
    Angle1 = Angle1 + 5;
    //---------相手の攻撃がバリアに当たった時の処理---------

    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より大きいとき
    if (A > baria_x && A < X2 && B > baria_y && B < Y2) {
      if (A < 400 && B > 500) {//左下2
        Angle1 = 90;
      }
    }
    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より小さいとき
    if (A > baria_x && A < X2 && B < baria_y && B > Y2) {
      if (A < 400 && B > 500) {//左下2
        Angle1 = 90;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より大きいとき
    if (A < baria_x && A > X2 && B > baria_y && B < Y2) {
      if (A < 400 && B > 500) {//左下2
        Angle1 = 90;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より小さいとき
    if (A < baria_x && A > X2 && B < baria_y && B > Y2) {
      if (A < 400 && B > 500) {//左下2
        Angle1 = 90;
      }
    }
    //------------------------------------------------------

//-----------------桃太郎が当たった時の処理----------------
    if (X-20 <= A && A<= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A+30 && A+30 <= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A - 30 && A - 30<= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//----------------------猿が当たった時の処理----------------
    if (X2-20 <= A && A<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A+30 && A+30 <= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A - 30 && A - 30<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------犬が当たった時の処理----------------
    if (X3-20 <= A && A<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A+30 && A+30 <= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A - 30 && A - 30<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------雉が当たった時の処理----------------
    if (X4-20 <= A && A<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A+30 && A+30 <= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A - 30 && A - 30<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------
    
  }
  //右上
  if (Angle2 > 0) {
    A = Cx2 + (R2 * cos(radians(Angle2)));
    B = Cy2 + (R2 * sin(radians(Angle2)));
    //描画
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(A, B, 20, 20);
    ellipse(A + 30, B, 20, 20);
    ellipse(A - 30, B, 20, 20);
    Angle2 = Angle2 - 5;

    //---------相手の攻撃がバリアに当たった時の処理---------

    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より大きいとき
    if (A > baria_x && A < X2 && B > baria_y && B < Y2) {
      if (A > 400 && B < 500) {//左上2
        Angle2 = 0;
      }
    }
    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より小さいとき
    if (A > baria_x && A < X2 && B < baria_y && B > Y2) {
      if (A > 400 && B < 500) {//左上2

        Angle2 = 0;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より大きいとき
    if (A < baria_x && A > X2 && B > baria_y && B < Y2) {
      if (A > 400 && B < 500) {//左上2
        Angle2 = 0;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より小さいとき
    if (A < baria_x && A > X2 && B < baria_y && B > Y2) {
      if (A > 400 && B < 500) {//左上2
        Angle2 = 0;
      }
    }
    //------------------------------------------------------

//-----------------桃太郎が当たった時の処理----------------
    if (X-20 <= A && A<= X + 20&& Y-20 <= B && B <= Y + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A+30 && A+30 <= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A - 30 && A - 30<= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//----------------------猿が当たった時の処理----------------
    if (X2-20 <= A && A<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A+30 && A+30 <= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A - 30 && A - 30<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------犬が当たった時の処理----------------
    if (X3-20 <= A && A<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A+30 && A+30 <= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A - 30 && A - 30<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------雉が当たった時の処理----------------
    if (X4-20 <= A && A<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A+30 && A+30 <= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A - 30 && A - 30<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------
    
    
  }
  //左上
  if (Angle3 < 180) {
    A = Cx3 + (R3 * cos(radians(Angle3)));
    B = Cy3 + (R3 * sin(radians(Angle3)));
    //描画
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(A, B, 20, 20);
    ellipse(A + 30, B, 20, 20);
    ellipse(A - 30, B, 20, 20);
    Angle3 = Angle3 + 5;

    //---------相手の攻撃がバリアに当たった時の処理---------

    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より大きいとき
    if (A > baria_x && A < X2 && B > baria_y && B < Y2) {
      if (A < 400 && B < 500) {//右上2
        Angle3 = 180;
      }
    }
    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より小さいとき
    if (A > baria_x && A < X2 && B < baria_y && B > Y2) {
      if (A < 400 && B < 500) {//右上2
        Angle3 = 180;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より大きいとき
    if (A < baria_x && A > X2 && B > baria_y && B < Y2) {
      if (A < 400 && B < 500) {//右上2
        Angle3 = 180;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より小さいとき
    if (A < baria_x && A > X2 && B < baria_y && B > Y2) {
      if (A < 400 && B < 500) {//右上2
        Angle3 = 180;
      }
    }
    //------------------------------------------------------
//-----------------桃太郎が当たった時の処理----------------
    if (X-20 <= A && A<= X + 20&& Y-20 <= B && B <= Y + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A+30 && A+30 <= X + 20&& Y-20 <= B && B <= Y + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A - 30 && A - 30<= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//----------------------猿が当たった時の処理----------------
    if (X2-20 <= A && A<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A+30 && A+30 <= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A - 30 && A - 30<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------犬が当たった時の処理----------------
    if (X3-20 <= A && A<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A+30 && A+30 <= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A - 30 && A - 30<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------雉が当たった時の処理----------------
    if (X4-20 <= A && A<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A+30 && A+30 <= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A - 30 && A - 30<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------
    
  }
  //右下
  if (Angle4 > 90) {
    A = Cx4 + (R4 * cos(radians(Angle4)));
    B = Cy4 + (R4 * sin(radians(Angle4)));
    //描画
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    ellipse(A, B, 20, 20);
    ellipse(A + 30, B, 20, 20);
    ellipse(A - 30, B, 20, 20);
    Angle4 = Angle4 - 5;

    //---------相手の攻撃がバリアに当たった時の処理---------

    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より大きいとき
    if (A > baria_x && A < X2 && B > baria_y && B < Y2) {
      if (A > 400 && B > 500) {//右下2
        Angle4 = 90;
      }
    }
    //X2座標がバリアx座標より大きく、Y2座標がバリアy座標より小さいとき
    if (A > baria_x && A < X2 && B < baria_y && B > Y2) {
      if (A > 400 && B > 500) {//右下2
        Angle4 = 90;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より大きいとき
    if (A < baria_x && A > X2 && B > baria_y && B < Y2) {
      if (A > 400 && B > 500) {//右下2
        Angle4 = 90;
      }
    }
    //X2座標がバリアx座標より小さく、Y2座標がバリアy座標より小さいとき
    if (A < baria_x && A > X2 && B < baria_y && B > Y2) {
      if (A > 400 && B > 500) {//右下2
        Angle4 = 90;
      }
    }
    //------------------------------------------------------
//-----------------桃太郎が当たった時の処理----------------
    if (X-20 <= A && A<= X + 20&& Y-20 <= B && B <= Y + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A+30 && A+30 <= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X-20 <= A - 30 && A - 30<= X + 20&& Y-20 <= B && B <= Y + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//----------------------猿が当たった時の処理----------------
    if (X2-20 <= A && A<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A+30 && A+30 <= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X2-20 <= A - 30 && A - 30<= X2 + 20&& Y2-20 <= B && B <= Y2 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------犬が当たった時の処理----------------
    if (X3-20 <= A && A<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A+30 && A+30 <= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X3-20 <= A - 30 && A - 30<= X3 + 20&& Y3-20 <= B && B <= Y3 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------


//-----------------雉が当たった時の処理----------------
    if (X4-20 <= A && A<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      enemy_oto.rewind();
      enemy_oto.play();
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A+30 && A+30 <= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
    if (X4-20 <= A - 30 && A - 30<= X4 + 20&& Y4-20 <= B && B <= Y4 + 20) {
      currentHp = currentHp - damage_teki;
      currentHp2 = currentHp2 - (damage_teki/2.5);
    }
//-----------------------------------------------------------
    
  }

  if (Angle1 == 90 && Angle2 == 0 && Angle3 == 180 && Angle4 == 90) {//攻撃ターンの終了条件
    enemyturn = 3;
    Angle1 = 0;
    Angle2 = 90;
    Angle3 = 90;
    Angle4 = 180;
  }
}

void Stop() {
  if (currentHp_teki == 0) {
    fill(0, 0, 255);
    textSize(50);
    text("ＹＯＵ　ＷＩＮ", 80, 400);//2
  }

  if (currentHp == 0) {
    while (flag == false) {
      image(lose, 0, 0, 800, 1000);//2
      fill(255, 0, 0);
      textSize(40);
      text("ＹＯＵ　ＬＯＳＥ", 80, 400); //2
      if (keyPressed) {
        flag = true;
      }
    }
  }
}
void stop1() {
  kouka.close();
  minim.stop();
  super.stop();
}



