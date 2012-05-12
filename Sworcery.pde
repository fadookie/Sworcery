/**
 * Untitled Sworcery A/V Jam 2012 entry
 * by Eliot Lash
 */

import ddf.minim.*;

AudioPlayer player;
Minim minim;
Triangle tri;

static final char TRI_TYPE_CORNER = 1;
static final char TRI_TYPE_CENTER = 2;

void setup()
{
  size(800, 800);
  frameRate(30);
  noSmooth();
  strokeWeight(1);

  minim = new Minim(this);
  
  // load a file, give the AudioPlayer buffers that are 1024 samples long
  // player = minim.loadFile("groove.mp3");
  
  // load a file, give the AudioPlayer buffers that are 2048 samples long
  player = minim.loadFile("UnknowableGeometry.mp3", 2048);
  // play the file
  player.play();
  
  tri = new Triangle(new PVector(width/2, height/2), 100, radians(0));
  noFill();
  strokeCap(SQUARE);
  strokeJoin(MITER);
}

void draw()
{
  background(0);
  stroke(255);
  pushMatrix();
  translate(0, (height / 2) - 100);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  // note that if the file is MONO, left.get() and right.get() will return the same value
  /*
  for(int i = 0; i < player.left.size()-1; i++)
  {
    line(i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50);
    line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
  }
  */
  popMatrix();
  
  tri.draw();
  //tri.scaleFactor += 0.01 * 2;
  //tri.rotation += radians(1 * 2);
}

void keyPressed() {
  if (CODED != key) {
    if ('s' == key) {
      saveFrame("screenshot.png");
      println("screenshot.png saved");
    }
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  player.close();
  minim.stop();
  
  super.stop();
}
