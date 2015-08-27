


import processing.pdf.*;



final boolean USE_IMAGE = false;
    // If you are using an image, define the image file name
    final String IMAGE_NAME = "bridge2.jpg";
   
    // If you are not using an image, define the size
    final int IMAGE_WIDTH = 1000; 
    final int IMAGE_HEIGHT = 500;

final boolean USE_ELLIPSE = true;
    //If we are using Ellipses, set the size
    final int ELLIPSESIZE = 10;
   
// determines if the resulting images should be saved   
final boolean SAVE_FRAMES = false;    
    
final int FILL_AMOUNT = 150;
final int STROKE_AMOUNT = 100;

final int NUM_WEBS = 3;

final int NUM_POINTS = 10;
final int MAX_NEIGHBORS = 4;

final int NUM_OUTPUT = 10;


PImage sourceImg;


int timesDrawn;



void setup() 
{

  timesDrawn = 0;
  
  background(255);


  if(USE_IMAGE)
  {
    sourceImg = loadImage(IMAGE_NAME);
    size(sourceImg.width, sourceImg.height);
  }
  else
  {
    size(IMAGE_WIDTH,IMAGE_HEIGHT);
  }

  smooth();
 

  stroke(0,STROKE_AMOUNT);
  
  frameRate(1);

}



void createWeb() 
{
  

  ArrayList<Integer> xValues = new ArrayList<Integer>();
  ArrayList<Integer> yValues = new ArrayList<Integer>();
  
  ArrayList<Integer> closestNeighbors = new ArrayList<Integer>();
  ArrayList<Float> closestNeighborsDiff = new ArrayList<Float>();
  

  
  float diff = 1000000;
  
  
  while(xValues.size() < NUM_POINTS)
  {
     addPoint(xValues, yValues); 
  }
  
  for(int i =0; i < xValues.size(); i++)
  {

    closestNeighbors.clear();
    closestNeighborsDiff.clear();
    
    for( int j = 0; j < xValues.size(); j++ )
    {
      diff = pow(xValues.get(i)- xValues.get(j),2) + pow(yValues.get(i)- yValues.get(j),2);
      diff = sqrt(diff);
      
      if( i != j )
     { 
        if( closestNeighbors.size() == 0 )
        {
          closestNeighborsDiff.add((Float)diff);
          closestNeighbors.add(j);
        }
        else // if( diff < closestNeighborsDiff.get(closestNeighborsDiff.size()-1) )
        {
         
          for( int ii = 0; ii < closestNeighbors.size(); ii++ )
          {
            //MAX_NEIGHBORS
            if( diff < closestNeighborsDiff.get(ii))
            {
              if( closestNeighbors.size() == MAX_NEIGHBORS)
              {
                //closestNeighborsDiff.remove(closestNeighborsDiff.size()-1);
                //closestNeighbors.remove(closestNeighbors.size()-1);
                closestNeighborsDiff.remove(ii);
                closestNeighbors.remove(ii);
                
              }
              else
              {
              }
              
              closestNeighborsDiff.add((Float)diff);
              closestNeighbors.add(j);
            }
          }

          
        }
     }
      
      
    }
    
    

    for(int ii = 0; ii< closestNeighbors.size(); ii++)
    {
      int index = closestNeighbors.get(ii);
      
      //println(xValues.get(i) + " " + yValues.get(i) + " " + xValues.get(index) + " " + yValues.get(index));
      line(xValues.get(i),yValues.get(i), xValues.get(index),yValues.get(index));
    }

    
  }
  
  // add the ellipses
  if(USE_ELLIPSE)
  {
    for( int i =0; i < xValues.size(); i++)
    {
        fill(FILL_AMOUNT);
        ellipse(xValues.get(i), yValues.get(i), ELLIPSESIZE, ELLIPSESIZE); 
    }
  }
  

    
}

void addPoint(ArrayList<Integer> xValues, ArrayList<Integer> yValues)
{
  
  boolean addThisPoint = false;
  
  int randomX = (int)random(width);
  int randomY = (int)random(height);
  
  if(USE_IMAGE)
  {
    sourceImg.loadPixels(); 
    
    float avg;
    
    int loc = randomX + randomY*width;
          
    // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
    float r = red(sourceImg.pixels[loc]);
    float g = green(sourceImg.pixels[loc]);
    float b = blue(sourceImg.pixels[loc]);
    
    avg = (r+g+b)/3.0;
    
    float randomCriteria = random(255);
    
    addThisPoint = randomCriteria > avg;
  
  }
  else
  {
    addThisPoint = true;
  }
  
  

  if( addThisPoint )
  {

    xValues.add(randomX);
    yValues.add(randomY);
  }  
  

}

void draw() 
{
  
  System.out.println("OUTPUT " + timesDrawn + "/" + NUM_OUTPUT);
  
    background(255);
    for(int i = 0; i < NUM_WEBS; i++ )
     { 
      createWeb(); 
      println("i = " + i);
     }
     
     if( SAVE_FRAMES)
     {
        saveFrame("coverPicture-######.png");
     }
    
    timesDrawn++;
    
    if( timesDrawn > NUM_OUTPUT -1)
    {
      noLoop();
    }
    
    
}


