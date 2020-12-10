/* @pjs preload="data\snake_body_0.png"; */
/* @pjs preload="data\snake_body_1.png"; */
/* @pjs preload="data\snake_body_2.png"; */
/* @pjs preload="data\snake_body_3.png"; */
/* @pjs preload="data\snake_head_0.png"; */
/* @pjs preload="data\snake_head_1.png"; */
/* @pjs preload="data\snake_head_2.png"; */
/* @pjs preload="data\snake_head_3.png"; */
/* @pjs preload="data\snake_tail_0.png"; */
/* @pjs preload="data\snake_tail_1.png"; */
/* @pjs preload="data\snake_tail_2.png"; */
/* @pjs preload="data\snake_tail_3.png"; */
/* @pjs font="data\LucidaBright-DemiItalic-16.ttf"; */

// X, Y Location Class
class Axes
{
  public int x, y;
}


// Body Image Files
class BodyImageFiles
{
  public String Head, Body, Tail, Ext;
}


// Body Images
class BodyImages
{
  int i;

  public PImage Head[], Body[], Tail[];
  public int Orients;
  
  BodyImages(BodyImageFiles files, int orients)
  {
    Head = new PImage[orients];
    Body = new PImage[orients];
    Tail = new PImage[orients];
    Orients = orients;
    if(files.Head.length() > 0)
        for(i=0; i<orients; i++)
        Head[i] = loadImage(files.Head + i + files.Ext);
    if(files.Body.length() > 0)
        for(i=0; i<orients; i++)
        Body[i] = loadImage(files.Body + i + files.Ext);
    if(files.Tail.length() > 0)
        for(i=0; i<orients; i++)
        Tail[i] = loadImage(files.Tail + i + files.Ext);
  }
}



class SnakeFood
{
  PImage Img;
  int Score;
  Axes Position;
  
  // Initialization
  SnakeFood(String file, int score)
  {
    Img = loadImage(file);
    Score = score;
    Position = new Axes();
  }
  
  void Create(Axes step)
  {
    Position.x = int(random(0, ScreenSize.x / step.x)) * step.x;
    Position.y = int(random(0, ScreenSize.y / step.y)) * step.y;
  }
  
  void Display()
  {
    image(Img, Position.x, Position.y);
  }
}



// Snake Class
class Snake
{
  public BodyImages Img;
  public Axes Position;
  public Axes Step;
  public String Orientation;
  int State, Score;
  
  // Snake Object Constructor
  Snake(BodyImageFiles img_files, Axes pos, String orient, Axes step)
  {
    int i, j;
    
    // Load the snake images
  Img = new BodyImages(img_files, 4);
    
    // Save the position & orientation
    Position = new Axes();
    Step = new Axes();
    Position.x = pos.x;
    Position.y = pos.y;
    Orientation = orient;
    Step.x = step.x;
    Step.y = step.y;
  }
  
  
// Functions

  // Draw Snake
  void DrawSnake()
  {
    char c;
    PImage img_snake[];
    int i, j, x, y, end;
    
    x = Position.x;
    y = Position.y;
    end = Orientation.length() - 1;
    for(i=0; i<=end; i++)
    {
      // Select Snake segment
      if(i > 0 && i < end) img_snake = Img.Body;
      else if(i == 0) img_snake = Img.Head;
      else img_snake = Img.Tail;

      // Act accordingly
      c = Orientation.charAt(i);
      j = (int)(c-'a');
      image(img_snake[j], x, y);
      switch(c)
      {
        case 'a': x = (x - img_snake[j].width + ScreenSize.x) % ScreenSize.x;
        break;
        
        case 'b': y = (y + img_snake[j].height + ScreenSize.y) % ScreenSize.y;
        break;
        
        case 'c': x = (x + img_snake[j].width + ScreenSize.x) % ScreenSize.x;
        break;
        
        case 'd': y = (y - img_snake[j].height + ScreenSize.y) % ScreenSize.y;
        break;
        
        default: break;
      }
    }
  }
  
  
  // Set the Snake's position
  void SetPosition(int x, int y)
  {
    Position.x = x;
    Position.y = y;
  }



  int MoveSnake(char dir)
  {
    int i, len;
    char c;
    
    c = Orientation.charAt(0);
    if(dir == c || dir == (c - 2) || dir == (c + 2)) dir = c;
    len = Orientation.length() - 1;
    Orientation = dir + Orientation.substring(0, len);
    switch(dir)
      {
        case 'a': Position.x = (Position.x + Step.x + ScreenSize.x) % ScreenSize.x;
        break;
        
        case 'b': Position.y = (Position.y - Step.y + ScreenSize.y) % ScreenSize.y;
        break;
        
        case 'c': Position.x = (Position.x - Step.x + ScreenSize.x) % ScreenSize.x;
        break;
        
        case 'd': Position.y = (Position.y + Step.y + ScreenSize.y) % ScreenSize.y;
        break;
        
        default: break;
      }
//    println(Orientation);
    return(dir);
  }
}



// Global Variables
Snake snake0;
SnakeFood food0;
Axes ScreenSize;
long WaitCount, WaitTime;
PFont ScoreFont;

// Initialization
void setup()
{
  BodyImageFiles snakef = new BodyImageFiles();
  Axes pos = new Axes();
  Axes step = new Axes();
  
  ScreenSize = new Axes();
  ScreenSize.x = 640;
  ScreenSize.y = 480;
  WaitTime = 4;
  WaitCount = 0;
  size(640, 480);
  background(50, 58, 95);
  smooth();
  
  // Load Score font 
  ScoreFont = loadFont("data/LucidaBright-DemiItalic-16.vlw");
  
  // Load Snake0
  snakef.Head = "data/snake_head_";
  snakef.Body = "data/snake_body_";
  snakef.Tail = "data/snake_tail_";
  snakef.Ext = ".png";
  pos.x = 320;
  pos.y = 240;
  step.x = 14;
  step.y = 14;
  snake0 = new Snake(snakef, pos, "ccccccccccccccccccccccccccc", step);
  food0 = new SnakeFood("data/snake_tail_0.png", 1);
  food0.Create(step);
}



// Draw
void draw()
{
  char mv;
  Axes del = new Axes();
  
  if(WaitCount < WaitTime)
  {
    WaitCount++;
    return;
  }
    WaitCount = 0;
    background(50, 58, 95);
    if(mousePressed)
    {
      del.x = mouseX - snake0.Position.x;
      del.y = mouseY - snake0.Position.y;
      //if(abs(delX) + abs(delY) < 40) snake0.MoveSnake(snake0.Orientation.charAt(0));
      if(abs(del.x) > abs(del.y))
      {
        if(del.x > 0) mv = 'a';
        else mv = 'c';
      }
      else
      {
        if(del.y > 0) mv = 'd';
        else mv = 'b';
      }
    }
    else mv = snake0.Orientation.charAt(0);
    snake0.MoveSnake(mv);
    snake0.DrawSnake();
//    food0.Display();
    textFont(ScoreFont, 16);
    fill(255);
    text("Score: -320", 500, 20);
}
