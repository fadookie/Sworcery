/**
 * Untitled Sworcery A/V Jam 2012 entry
 * by Eliot Lash
 */

import ddf.minim.*;

AudioPlayer music;
Minim minim;
Trigon trigon;

//Types of TimeEvents
static final char EVENT_TYPE_PULSE = 1; //Change how a trigon is pulsing
static final char EVENT_TYPE_SCALE = 2; //Scale a trigon

static final char EVENT_NO_SUBTYPE = 0;

//Ways to draw a triangle, for Triangle#tri_type
static final char TRI_TYPE_CORNER = 1;  //Treat Triangle#pos as upper left corner of triangle
static final char TRI_TYPE_CENTROID = 2; //Treat Triangle#pos as centroid of triangle

//Types of Trigon pulses, for Trigon#triggerPulse
static final char PULSE_TYPE_PUSH = 1; //Push border out by one and add another border in the center
static final char PULSE_TYPE_PUSH_EMPTY = 2; //Push border out by one spacer
static final char PULSE_TYPE_PUSH_ADD = 3; //Push border out by one and add another border in the center, increasing max size
static final char PULSE_TYPE_PUSH_ADD_EMPTY = 4; //Push border out by one spacer, increasing max size
static final char PULSE_TYPE_SQUEEZE = 8; //Throb center triangle, squeeze
static final char PULSE_TYPE_ADD_BORDER = 9; //Add border around current one, up to specified max border amount

boolean DEBUG = false;
boolean tRotate = false;
boolean tScale = false;

float timeSongStarted;
float lastPulseTime = 0;
float pulseInterval = 60000 / 55; //Song is 55 BPM, there are 60000 Ms in a minute, pulse Interval is in beats per Ms

int screenshotCount = 0;

ArrayDeque<TimeEvent> events = new ArrayDeque<TimeEvent>();
ArrayList<TimeEvent> currentEvents = new ArrayList<TimeEvent>();

void setup()
{
  size(800, 800);
  frameRate(30);
  noSmooth();
  strokeWeight(1);

  noFill();
  strokeCap(SQUARE);
  strokeJoin(MITER);

  minim = new Minim(this);
  
  // load a file, give the AudioPlayer buffers that are 1024 samples long
  // music = minim.loadFile("groove.mp3");
  
  // load a file, give the AudioPlayer buffers that are 2048 samples long
  music = minim.loadFile("UnknowableGeometry.mp3", 2048);
  
  Triangle centerTri = new Triangle(
    new PVector(width/2, height/2),
    100,
    radians(0)
  );
  centerTri.solid = true;
  centerTri.myColor = color(212, 222, 177);

  trigon = new Trigon(centerTri);

  // play music
  //music.cue(25000);
  music.play();
  timeSongStarted = millis();
  println("songStarted = " + timeSongStarted);

  //Setup timed events
  {
    HashMap<String, Object> settings = new HashMap<String, Object>();
    settings.put("maxScale", new Integer(5));
    events.add(new TimeEvent(EVENT_TYPE_SCALE, EVENT_NO_SUBTYPE, 0, 28500, settings));
  }
  events.add(new TimeEvent(EVENT_TYPE_PULSE, PULSE_TYPE_PUSH, 28500));

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
  for(int i = 0; i < music.left.size()-1; i++)
  {
    line(i, 50 + music.left.get(i)*50, i+1, 50 + music.left.get(i+1)*50);
    line(i, 150 + music.right.get(i)*50, i+1, 150 + music.right.get(i+1)*50);
  }
  */
  popMatrix();
  
  if (tScale) {
    trigon.scaleFactor += 0.01 * 2;
  }
  if (tRotate) {
    trigon.rotation += radians(1 * 2);
  }


  //Identify events that should begin now
  try {
    TimeEvent nextEvent = events.peek();

    if (null != nextEvent
        && music.position() > nextEvent.start
    ){
        //Time for this event to happen!
        TimeEvent event = events.pop();
        currentEvents.add(event);
        println(event + " is starting at audio cue " + music.position());
    }
  } catch (NoSuchElementException e) {
  }


  //Process current events
  Iterator<TimeEvent> currentEventsIterator = currentEvents.iterator();
  while (currentEventsIterator.hasNext()) {
    TimeEvent currentEvent = currentEventsIterator.next();
    if (currentEvent.duration > 0
        && (music.position() - currentEvent.start) > currentEvent.duration
    ){
      //This event is over
      currentEventsIterator.remove();
    } else {
      //This event is still running

      if (EVENT_TYPE_PULSE == currentEvent.type) {
        if ((millis() - lastPulseTime) > pulseInterval) {
          lastPulseTime = millis();
          trigon.triggerPulse(currentEvent.subtype);
        }
      } else if (EVENT_TYPE_SCALE == currentEvent.type) {
        Integer maxScale = (Integer)currentEvent.additionalSettings.get("maxScale");
        if (maxScale != null) {
          trigon.scaleFactor = lerp(1, maxScale, currentEvent.getCompletion(music.position()));
        } else {
          //Default to just scaling it up
          trigon.scaleFactor += 0.01;
        }
      }
    }
  }

  trigon.update();
  trigon.draw();
}

void keyPressed() {
  if (CODED != key) {
    if ('S' == key) {
      try {
        saveFrame(String.format("screenshot%02d.png", screenshotCount));
        println("screenshot " + screenshotCount);
        screenshotCount++;
      } 
      catch (Exception e) {
      }
    } else if ('d' == key) {
      DEBUG = !DEBUG;
      println("DEBUG == " + DEBUG);
    } else if ('s' == key) {
      tScale = !tScale;
    } else if ('r' == key) {
      tRotate = !tRotate;
    } else if ('p' == key) {
      trigon.triggerPulse(PULSE_TYPE_PUSH);
    } else if ('P' == key) {
      trigon.triggerPulse(PULSE_TYPE_PUSH_ADD);
    } else if ('t' == key) {
      trigon.triggerPulse(PULSE_TYPE_SQUEEZE);
    } else if ('b' == key) {
      trigon.triggerPulse(PULSE_TYPE_ADD_BORDER);
    } else if ('e' == key) {
      trigon.triggerPulse(PULSE_TYPE_PUSH_EMPTY);
    } else if ('E' == key) {
      trigon.triggerPulse(PULSE_TYPE_PUSH_ADD_EMPTY);
    } else if ('=' == key) {
      trigon.maxBorders++;
      println("maxBorders == " + trigon.maxBorders);
    } else if ('-' == key) {
      trigon.maxBorders--;
      println("maxBorders == " + trigon.maxBorders);
    } else if (' ' == key) {
      //Toggle music
      if(music.isPlaying()) {
        music.pause();
      } else {
        music.play();
      }
    } else if ('>' == key) {
      music.skip(10000);
    } else if ('<' == key) {
      music.skip(-10000);
    }
  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  music.close();
  minim.stop();
  
  super.stop();
}
