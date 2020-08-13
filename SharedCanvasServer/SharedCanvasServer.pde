/**
 * Shared Drawing Canvas (Server) 
 * Initial app idea: Alexander R. Galloway. 
 * using multithreading  : Sinbrive 2020 
 */

import java.net.*;
import java.io.*;

Socket clientSocket; 
ServerSocket serveurSocket = null; 
DataInputStream in = null;  //  BufferedReader in
DataOutputStream out = null; //  PrintWriter out

int PORT = 12345;
int data[];
int received[]={0, 0, 0, 0};
String toSend="";

void setup() {
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(10); // Slow it down a little


  try {
    serveurSocket = new ServerSocket(12345);
    clientSocket = serveurSocket.accept();
    toSend=0 + " " + 0 + " " + 0 + " " + 0 + "\n";
    in = new DataInputStream( 
      new BufferedInputStream(clientSocket.getInputStream())); 
    // sends output to the socket 
    out = new DataOutputStream(clientSocket.getOutputStream());

    Thread envoi= new Thread(new Runnable() {
      @Override
        public void run() {
        while (true) {
          try {
            out.writeUTF(toSend);
            out.flush();
            Thread.sleep(100);
          }
          catch(Exception e) {
          }
        }
      }
    }
    );
    envoi.start();


    Thread recevoir= new Thread(new Runnable() {
      @Override
        public void run() {
        try {
          while (true) {
            if (in.available()>0) {
              String input = in.readUTF(); 
              input = input.substring(0, input.indexOf("\n")); // Only up to the newline
              data = int(split(input, ' ')); // Split values into an array
              // make received coords available
              received=data;
              try {
                Thread.sleep(100);
              }
              catch (Exception e) {
              }
            }
          }
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
    ); 
    recevoir.start();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}

void draw() {
  if ( mousePressed==true) {
    // Draw our line
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY);
    // Send mouse coords to other person
    toSend=pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n";
  }
  stroke(0);
  line(received[0], received[1], received[2], received[3]);
}
