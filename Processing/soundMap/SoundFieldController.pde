
// SoundMap, Lars Kaltenbach, 2013
// ·························································
// The SoundFieldController class controls the SoundFields
// ·························································

class SoundFieldController {
  ArrayList<SoundField> fields;
  boolean modify = false;
  
//····· CONSTRUCTOR START ·····// 
  // initialize with a given amount of SoundFields
  SoundFieldController(int _initialFields) {
    fields = new ArrayList<SoundField>();
    for (int i = 0; i < _initialFields; i++) {
      fields.add(new SoundField(i));
    }
  }
  // initialize with a saved table
  SoundFieldController(Table table) {
    fields = new ArrayList<SoundField>();
    processMapping(table);
  }
//····· CONSTRUCTOR END ·····// 
  
//····· FIELD CONTROLLER START ·····// 
  //render the fields
  void render() {
    for (SoundField sf : fields) sf.render(modify);
  }
  // calculate if field is activated 
  void update(PVector pos) {
    for (SoundField sf : fields) sf.update(pos);
  }
  // switch between edit mode
  void modify() {
    modify = !modify;
  }
  // add a new field
  void addField() {
    fields.add(new SoundField(fields.size()));
  } 
//····· FIELD CONTROLLER END ·····//  

//····· SAVE & LOAD MAPPING START ·····//
  // save the current layout
  void saveMapping() {
    Table table = new Table();
    table.addColumn("id");
    for (byte i = 1; i <= 3; i++) {
      table.addColumn("v_"+i+"X");
      table.addColumn("v_"+i+"Y");
    }
    // create a new row for every field
    for (SoundField sf : fields) {
      TableRow newRow = table.addRow();
      newRow.setInt("id", sf.id);
      for (byte i = 1; i <= 3; i++) {
        newRow.setFloat("v_"+i+"X", sf.verts[i-1].x);
        newRow.setFloat("v_"+i+"Y", sf.verts[i-1].y);
      }
    }
    // save the file with a timestamp
    String path = "data/mapping_"+year()+month()+day()+hour()+minute()+second()+".csv";
    saveTable(table, path, "header, csv");
    println("saved: "+path);
  }
  // call native "open file"-dialog
  void loadMapping() {
    // fileSelected has to be in the main sketch???
    selectInput("Select a folder with mapping information:", "fileSelected"); 
  }
  // read the positions from a given table
  void processMapping(Table table) {
    for (TableRow row : table.rows()) {
      fields.add(new SoundField(row.getInt("id")));
      SoundField sf = fields.get(row.getInt("id"));
      sf.verts[0] = new PVector(row.getFloat("v_1X"), row.getFloat("v_1Y")); 
      sf.verts[1] = new PVector(row.getFloat("v_2X"), row.getFloat("v_2Y")); 
      sf.verts[2] = new PVector(row.getFloat("v_3X"), row.getFloat("v_3Y"));
    }
  }
//····· SAVE  & LOAD MAPPING END ·····//
}  

