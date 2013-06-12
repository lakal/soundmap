
// SoundMap, Lars Kaltenbach, 2013
// ·························································
// The SoundFieldController class describes the behaviour of the SoundFields
// ·························································

class SoundField {
  PVector[] verts = new PVector[3];
  int id;
  int activity = 255;
  boolean isPlaying = false;
  
//····· CONSTRUCTOR START ·····//
  SoundField(int _id) {
    id = _id;
    // for alternating triangles
    calculateFieldPoints(id);
  }
//····· CONSTRUCTOR END ·····//

//····· DISPLAY START ·····//  
  void render(boolean _modify) {
    fill(255);
    if(_modify) { 
      modify(); 
    } else {  
      fill(0,0, activity); 
      if(isPlaying) playSound(id); 
    }
    noStroke();
    beginShape();
    for (int i=0; i< verts.length; i++) vertex(verts[i].x, verts[i].y);
    endShape();
  }
//····· DISPLAY END ·····//  

//····· CALCULATION START ·····//    
  void update(PVector pos) {
    // <= 20: can be played again even if the field hasnt completly disappeared
    if(pos != null && isVectorInField(pos) && activity <= 20) isPlaying = true; 
    // fade the activated fields out
    activity -= 5;  
  }
//····· CALCULATION END ·····//    

//····· EDIT MODE START ·····//      
  void modify() {
    fill(255,0,0);
    if(mousePressed) {
      for(int i = 0; i < verts.length; i++) {
        float distance = dist(mouseX, mouseY, verts[i].x, verts[i].y);
        // if mouse is near a field vector, snap the vecotr to the mouse
        if(distance <= 30) {
          verts[i] = new PVector(mouseX, mouseY);
        }
      }
    }
  }
//····· EDIT MODE END ·····//      
  
//····· HIT TEST START ·····//  
  private boolean isVectorInField(PVector pos) {
    int i, j;
    boolean c = false;
    int sides = verts.length;
    for (i = 0, j = sides - 1; i < sides; j = i++) {
      if (( ((verts[i].y <= pos.y) && (pos.y < verts[j].y)) || ((verts[j].y <= pos.y) && (pos.y < verts[i].y))) &&
            (pos.x < (verts[j].x - verts[i].x) * (pos.y - verts[i].y) / (verts[j].y - verts[i].y) + verts[i].x)) {
        c = !c;
      }
    }
    return c;
  }  
//····· HIT TEST END ·····//  

//····· CALCULATE POSITION START ·····// 
  private void calculateFieldPoints(int id) {
    int posX = 0;
    int posY = 100;
    int w = 80;
    int h = 80;
    int offset = 30 + (w * id);
    
    if(id > 5) { 
      posY = 230; 
      offset = 30 + (w * id)-500;
    }

    if (id % 2 == 0) {
      // gerade id
      verts[0] = new PVector(posX+offset, posY-h);
      verts[1] = new PVector(posX+w+offset, posY-h);
      verts[2] = new PVector(posX+w/2+offset, posY);
    } else {
      // even id
      verts[0] = new PVector(posX+offset, posY);
      verts[1] = new PVector(posX+w+offset, posY);
      verts[2] = new PVector(posX+w/2+offset, posY-h);
    }
  }
//····· CALCULATE POSITION END ·····// 
  
//····· PLAY SOUND START ·····//   
  private void playSound(int transpose) {
      float pitch=getPitchForSemitone(transpose);
      AudioSource currVoice=soundManager.getNextVoice();
      currVoice.setBuffer(buf);
      currVoice.setPitch(pitch);
      currVoice.play();
      // prevent sound from repeating
      isPlaying = false;
      activity = 255;
  }
  
  float getPitchForSemitone(int st) {
    return (float) Math.pow(2, st / 12.0);
  }
//····· PLAY SOUND END ·····//   
}

