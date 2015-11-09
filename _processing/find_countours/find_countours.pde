import gab.opencv.*;

PrintWriter output;
PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
Contour bigContour;
ArrayList<Contour> polygons;

void setup() {
  
  output = createWriter("cabrillo_countours.txt");
  src = loadImage("cabrillo.jpg"); 
  size(src.width, src.height/2);
  opencv = new OpenCV(this, src);

  opencv.gray();
  opencv.threshold(70);
  dst = opencv.getOutput();

  contours = opencv.findContours();
  println("found " + contours.size() + " contours");
  
  int biggestContour = -1;
  int biggestContourIndex = -1;
  
  for (int i = 0; i < contours.size(); i++){
    
    int thisSize = contours.get(i).getPoints().size();
    
    if (thisSize >= biggestContour){
     
     biggestContourIndex = i;
     biggestContour = thisSize;
     
    }
    //println("size: " + contours.get(i).getPoints().size());
    
  }
  
  println("Biggest contour length is " + biggestContour);
  
  // Write contours.
  if (biggestContourIndex > -1){
    ArrayList<PVector> contourPoints = contours.get(biggestContourIndex).getPoints();
    
    bigContour = contours.get(biggestContourIndex);
    
    for (int p=0; p < contourPoints.size(); p++){
      
      PVector pos = contourPoints.get(p);
      
  
    }
  }
  
  normalizeAndExport( bigContour );
}

void normalizeAndExport( Contour iContour ){
  
  float minX = 999999999;
  float maxX = -99999999;
  
  float minY = 99999999;
  float maxY = -99999999;
  
  ArrayList<PVector> cPoints = iContour.getPoints();
  
  for (int i =0; i < cPoints.size(); i++){
   
    PVector p = cPoints.get(i);
    
    maxX = max(p.x, maxX);
    maxY = max(p.y, maxY);
    
    minX = min(p.x, minX);
    minY = min(p.y, minY);
    
  }
  
 
  // Now normalize and write
    for (int i =0; i < cPoints.size(); i++){
   
    PVector p = cPoints.get(i);
    
    float normX = map(p.x, minX, maxX, 0, 1.0);
    float normY = map(p.y, minY, maxY, 0, 1.0);
    
    output.println(normX + ";");
  
  }
  
  output.flush();
  output.close();
  

}

void draw() {
  scale(0.5);
  image(src, 0, 0);
  image(dst, src.width, 0);

  noFill();
  strokeWeight(3);
  
  // Only draw the biggest contour.
  Contour contour = bigContour;
  
//  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.draw();
    
    stroke(255, 0, 0);
    beginShape();
 
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
//  }
}

