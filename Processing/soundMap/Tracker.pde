
// SoundMap, Lars Kaltenbach, 2013
// ·························································
// The Tracker class reads the messages provided by CCV (http://ccv.nuigroup.com)
// ·························································

class Tracker {
  OscP5 oscP5;
  PVector location;
  boolean modify = false;

//····· CONSTRUCTOR START ·····//  
  Tracker(PApplet p, int port) {
      oscP5 = new OscP5(this, 3333);
      location = null;
  }
//····· CONSTRUCTOR END ·····//  

//····· BLOB DETECTION START ·····//    
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkTypetag("sifffff")) {
    float x = theOscMessage.get(2).floatValue();
    float y = theOscMessage.get(3).floatValue();
    location = new PVector(map(x, 0, 1, 0, width), map(y, 0, 1, 0, height));
  } 
}

PVector getPos() {
  PVector tempLoc = location;
  if(modify == true && tempLoc != null) { fill(0,255,0); ellipse(tempLoc.x, tempLoc.y, 20, 20); }
  location = null;
  return tempLoc;  
}

//····· BLOB DETECTION END ·····//    

//····· HELPER FUNCTIONS START ·····//      
  // enter edit mode
  void modify() {
    modify = !modify;
  }
//····· HELPER FUNCTIONS END ·····//        
}
