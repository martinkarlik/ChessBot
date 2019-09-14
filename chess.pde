Board board;
int scl;
String result = "";
Piece[][] squares = new Piece[8][8];
Piece[][] squaresCopy = new Piece[8][8];
PImage[] imgs = new PImage[32];

void setup() {
  size(1600, 1600);
  scl = width/8; //the board is square shaped
  loadImages();
  
  board = new Board(); 
}

void draw() {
  board.display();
  //println(board.whiteTurn);
  if (result == "white") {
    board.displayMessage("WHITE WINS");  
  } else if (result == "black") {
    board.displayMessage("BLACK WINS");  
  } else if (result == "stalemate") {
    board.displayMessage("STALEMATE");  
  }
  if (board.check) {
    fill(200, 200, 0);  
  } else {
    fill(0, 200, 200);  
  }
  ellipse(100, 100, 30, 30);
}

void mousePressed() {
  board.piecePicked();   
}

void mouseDragged() {
  board.pieceDragged(); 
}

void mouseReleased() {
  board.pieceDropped();
}

void loadImages() {
  String clrs[] = new String [2];
  clrs[0] = "white";
  clrs[1] = "black";
  String pieces[] = new String [6];
  pieces[0] = "Pawn";
  pieces[1] = "Bishop";
  pieces[2] = "Knight";
  pieces[3] = "Rook";
  pieces[4] = "Queen";
  pieces[5] = "King";
  
  int count = 0;
  for (int i = 0; i < clrs.length; i++) {
    for (int j = 0; j < pieces.length; j++) {
      imgs[count++] = loadImage(clrs[i]+pieces[j]+".png");  
    }
  }
}

void keyPressed() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      squares[i][j] = null;  
    }
  }
  for (Piece p: board.whitePieces) {
    println(p);  
  }
}

//photoshop final version of pieces
//check
