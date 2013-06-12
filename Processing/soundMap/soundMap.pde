
// SoundMap, Lars Kaltenbach, 2013
// http://www.larskaltenbach.com
// ·························································
// The Sound Map is an experimental sound interface. 
// The Sketch draws triangles which can be adjusted to the surface of an object.
// When you point a laser on a triangle it lights up and plays a sound.
// ·························································
// Credits:
// toxiclibs: used for sound generation (http://toxiclibs.org)
// oscP5: used for reading tuio messages (http://www.sojamo.de/libraries/oscp5)
// Robert Moggach: hit test code from (https://forum.processing.org/topic/how-do-i-find-if-a-point-is-inside-a-complex-polygon) 
// CCV: used for blob tracking ad sending tuio messages (http://ccv.nuigroup.com)
// ·························································

import toxi.processing.*;
import toxi.geom.Vec3D;
import toxi.audio.*;
import oscP5.*;

SoundFieldController controller;
int initialFields = 13;

Tracker tracker;

JOALUtil audioSys;
MultiTimbralManager soundManager;
AudioBuffer buf;
  
void setup() {
  size(800, 600, P2D);
  controller = new SoundFieldController(initialFields);
  initAudio(initialFields);
  tracker = new Tracker(this, 3333);
}

void draw() {
  background(0);
  PVector cursor = new PVector(mouseX, mouseY);  
  // use OpenCV blob tracker:
  //PVector cursor = tracker.getPos();
  controller.update(cursor);
  controller.render();
}

//····· OPTIONS START ·····//
void keyPressed() {
  // start modify mode
  if(key == 'm') controller.modify(); tracker.modify(); 
  if(controller.modify) {
    // save current layout
    if(key == 's') controller.saveMapping();
    // load old layout 
    if(key == 'l') controller.loadMapping();
    // add field 
    if(key=='+') { 
      controller.addField(); 
      initialFields++;
      initAudio(initialFields);
    }
    if(key == 'r') { // relaod start settings
      initialFields = 5; 
      controller = new SoundFieldController(initialFields); 
      initAudio(initialFields); } 
    }
}
//····· OPTIONS END ·····//

//····· INITIALIZE AUDIO START ·····//
void initAudio(int _initialFields) {
  audioSys = JOALUtil.getInstance();
  soundManager=new MultiTimbralManager(audioSys, _initialFields);
  buf=audioSys.loadBuffer(dataPath("synth.wav"));
}
public void stop() {
  audioSys.shutdown();
}
//····· INITIALIZE AUDIO END·····//

//····· FILE LOADER START ·····//
// selectInput can't be called from within the controller class???
void fileSelected(File file) { 
  if (file != null) {      
    String path = file.getAbsolutePath(); 
    Table table = loadTable(path, "header, csv");
    controller = new SoundFieldController(table);
    initAudio(table.getRowCount() -1 );  
  }
}
//····· FILE LOADER END ·····//
 
