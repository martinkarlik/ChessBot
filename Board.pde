  class Board {
  ArrayList<Piece> whitePieces;
  ArrayList<Piece> blackPieces;
  ArrayList<Piece> whitePiecesCopy;
  ArrayList<Piece> blackPiecesCopy;
  boolean whiteTurn;
  PVector lastMove;
  int totalLegalMoves;
  boolean check;
  boolean checkCopy;
  
  Board() {
    whiteTurn = true;   
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        squares[i][j] = null; 
        squaresCopy[i][j] = null;
      }
    }
    check = false;
    
    whitePieces = new ArrayList<Piece>();
    whitePieces.add(new King(new PVector(4, 0), true));
    whitePieces.add(new Queen(new PVector(3, 0), true));
    whitePieces.add(new Rook(new PVector(0, 0), true));
    whitePieces.add(new Rook(new PVector(7, 0), true));
    whitePieces.add(new Knight(new PVector(1, 0), true));
    whitePieces.add(new Knight(new PVector(6, 0), true));
    whitePieces.add(new Bishop(new PVector(2, 0), true));
    whitePieces.add(new Bishop(new PVector(5, 0), true));
    for (int i = 0; i < 8; i++) {
      whitePieces.add(new Pawn(new PVector(i, 1), true));  
    }
   
    blackPieces = new ArrayList<Piece>();  
    blackPieces.add(new King(new PVector(4, 7), false));
    blackPieces.add(new Queen(new PVector(3, 7), false));
    blackPieces.add(new Rook(new PVector(0, 7), false));
    blackPieces.add(new Rook(new PVector(7, 7), false));
    blackPieces.add(new Knight(new PVector(1, 7), false));
    blackPieces.add(new Knight(new PVector(6, 7), false));
    blackPieces.add(new Bishop(new PVector(2, 7), false));
    blackPieces.add(new Bishop(new PVector(5, 7), false));
    for (int i = 0; i < 8; i++) {
      blackPieces.add(new Pawn(new PVector(i, 6), false));  
    }
    
    whitePiecesCopy = new ArrayList<Piece>();
    blackPiecesCopy = new ArrayList<Piece>();
    
    for (Piece p: whitePieces) {
      p.findLegalMoves(true);  
    }
    
  }
  
  void display() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        fill(0);
        if ((i+j)%2==1) {
          fill(255);  
        }
        rect(i*scl, j*scl, scl, scl);
      }  
    }
    for (Piece p: whitePieces) {
      p.display();
    }
    for (Piece p: blackPieces) {
      p.display();
    }
  }
  
  void piecePicked() {
    if (whiteTurn) {
      for (Piece p: whitePieces) {
        if (mouseX > p.pxPos.x && mouseX < p.pxPos.x+scl && mouseY > p.pxPos.y && mouseY < p.pxPos.y+scl) { 
          p.isPicked = true;
          p.priorPxPos = p.pxPos.copy();
          break; //Checking if any of the pieces have been selected with mouse, once any of them has been selected, stop checking
        }
      }   
    } else {
      for (Piece p: blackPieces) {
        if (mouseX > p.pxPos.x && mouseX < p.pxPos.x+scl && mouseY > p.pxPos.y && mouseY < p.pxPos.y+scl) { 
          p.isPicked = true;
          p.priorPxPos = p.pxPos.copy();
          break; //Checking if any of the pieces have been selected with mouse, once any of them has been selected, stop checking
        }
      }   
    }
  }
  
  void pieceDragged() {
    if (whiteTurn) {
      for (Piece p: whitePieces) {
        if (p.isPicked) {
          p.pxPos.x = mouseX-scl/2;
          p.pxPos.y = mouseY-scl/2;  
          break;
        }
      }  
    } else {
      for (Piece p: blackPieces) {
        if (p.isPicked) {
          p.pxPos.x = mouseX-scl/2;
          p.pxPos.y = mouseY-scl/2;    
          break;
        }
      }  
    }
  }  
  
  void pieceDropped() {
    if (whiteTurn) {
      for (Piece p: whitePieces) {
        if (p.isPicked) { //3 scenarios of making a move: legal move (end of his turn), illegal move (warning, no end of his turn), return to the same square (no warning, no end of his turn)
          if (mouseX - mouseX % scl == p.priorPxPos.x && mouseY - mouseY % scl == p.priorPxPos.y) { //piece returned to the same square (player's having second thoughts)
            p.boardPos = p.pxToBoard(new PVector(mouseX, mouseY)); 
            p.pxPos = p.boardToPx(p.boardPos.copy());  
          } else if (!p.inLegalMoves(new PVector(mouseX, mouseY))) { //illegal move
            p.illegalMove();  
          } else { //legal move was played
            
            p.makeMove(new PVector(mouseX, mouseY), true); //physically (well, not "physically"..) move the piece, the boolean parameter - is the move played or just analysed?
            
            check = false; //is the side that just made the move attacking opponent's king? let's find out (inside the findLegalMoves method) 
            
            for (Piece w: whitePieces) { //team that just moved resets its legal moves, but we also need to check, if the opponent is in check - by checking if the king is endangered  
              if (!check) {
                w.findLegalMoves(true); //is any piece controlling the king's square? just one is enough
              }
              w.legalMoves.clear(); //regardless, we need to clear the pieces' legal moves (it would be nice at least)
            } //at the end of this for loop, we know the value of check (true/false)
            
            totalLegalMoves = 0; //we need to count the legal moves to determine whether it's checkmate or stalement or none of the above 
            
            for (Piece b: blackPieces) {
              b.findLegalMoves(true);
              if (check) {
                b.reduceLegalMoves();  
              }
              totalLegalMoves += b.legalMoves.size();
              println(b.legalMoves);
            }
            println(totalLegalMoves);
            
            if (totalLegalMoves == 0) {
              if (check) {
                result = "white";
              } else {
                result = "stalemate";
              }
            }
          }
          p.isPicked = false;
          break; 
        }
      }     
    } else {
      for (Piece p: blackPieces) {
        if (p.isPicked) { 
          if (mouseX - mouseX % scl == p.priorPxPos.x && mouseY - mouseY % scl == p.priorPxPos.y) { 
            p.boardPos = p.pxToBoard(new PVector(mouseX, mouseY)); 
            p.pxPos = p.boardToPx(p.boardPos.copy());  
          } else if (!p.inLegalMoves(new PVector(mouseX, mouseY))) {
            p.illegalMove();  
          } else {
            
            p.makeMove(new PVector(mouseX, mouseY), true); //physically (well, not "physically"..) move the piece
            
            check = false; //is the side that just made the move attacking opponent's king? let's find out (inside the findLegalMoves method) 
            
            for (Piece b: blackPieces) { //team that just moved resets its legal moves, but we also need to check, if the opponent is in check - by checking if the king is endangered  
              if (!check) {
                b.findLegalMoves(true); //is any piece controlling the king's square? just one is enough
              }
              b.legalMoves.clear(); //regardless, we need to clear the pieces' legal moves (it would be nice at least)
            }
            
            totalLegalMoves = 0; //we need to count the legal moves to determine whether it's checkmate or stalement or none of the above 
            
            for (Piece w: whitePieces) {
              w.findLegalMoves(true); 
              if (check) {
                w.reduceLegalMoves();  
              }
              totalLegalMoves += w.legalMoves.size();
            }
            
            if (totalLegalMoves == 0) {
              if (check) {
                result = "black";
              } else {
                result = "stalemate";
              }
            }
          }
          p.isPicked = false;
          break; 
        }
      }
    }
  }
  
  boolean simulatePosition(Piece p, PVector move) { //analyses the move without playing it
    getPiecesCopy();
    Piece pCopy;
    
    if (p.isWhite) {
      pCopy = whitePiecesCopy.get(whitePieces.indexOf(p));
    } else {
      pCopy = blackPiecesCopy.get(blackPieces.indexOf(p));  
    }
    pCopy.makeMove(move, false);
    
    checkCopy = false;
    if (p.isWhite) {
      for (Piece b: blackPiecesCopy) {
        b.findLegalMoves(false);    
      }
    } else {
      for (Piece w: whitePieces) {
        w.findLegalMoves(false);    
      }  
    }
    return checkCopy;    
  }
  
  void getPiecesCopy() { //manual copy to avoid problems.. "squaresCopy = squares" would copy just the reference, but we want two individually manipulatable arrays  
    whitePiecesCopy.clear();
    blackPiecesCopy.clear();
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        squaresCopy[i][j] = null;
      }
    }
    
    for (Piece p: whitePieces) {
      if (p instanceof Pawn) {
        whitePiecesCopy.add(new Pawn(p));  
      } else if (p instanceof Bishop) {
        whitePiecesCopy.add(new Bishop(p));  
      } else if (p instanceof Knight) {
        whitePiecesCopy.add(new Knight(p));  
      } else if (p instanceof Rook) {
        whitePiecesCopy.add(new Rook(p));  
      } else if (p instanceof Queen) {
        whitePiecesCopy.add(new Queen(p));  
      } else if (p instanceof King) {
        whitePiecesCopy.add(new King(p));  
      }
    }
    for (Piece p: blackPieces) {
      if (p instanceof Pawn) {
        blackPiecesCopy.add(new Pawn(p));  
      } else if (p instanceof Bishop) {
        blackPiecesCopy.add(new Bishop(p));  
      } else if (p instanceof Knight) {
        blackPiecesCopy.add(new Knight(p));  
      } else if (p instanceof Rook) {
        blackPiecesCopy.add(new Rook(p));  
      } else if (p instanceof Queen) {
        blackPiecesCopy.add(new Queen(p));  
      } else if (p instanceof King) {
        blackPiecesCopy.add(new King(p));  
      }
    }
  }
  
  void displayMessage(String msg) {
    println(msg); //obviously not  
  }
  
}
