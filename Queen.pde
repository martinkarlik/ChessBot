class Queen extends Piece {
  
  Queen(Piece queen) {
    super(queen);
    this.pieceValue = queen.pieceValue;
    squaresCopy[x][y] = this;
  }
  
  Queen(PVector boardPos_, boolean isWhite_) {
    super(boardPos_, isWhite_);
    pieceValue = 9.0*dir;
    
    squares[x][y] = this; 
  }
  
  void display() {
    image(imgs[(1-int(isWhite))*6+4], pxPos.x, pxPos.y); 
  }
  
  void findLegalMoves(boolean onBoard) {
    Piece[][] tempSquares;
    if (onBoard) {
      tempSquares = squares; //see, here, I just need to reference to right thing, Im not making actual copy    
    } else {
      tempSquares = squaresCopy;  
    }
    legalMoves.clear();
    int tempX = x+1;
    int tempY = y;
    while (tempX < 8) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX++, tempY));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempX = x-1;
    while (tempX >= 0) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX--, tempY));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempX = x;
    tempY = y-1;
    while (tempY >= 0) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX, tempY--));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempY = y+1;
    while (tempY < 8) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX, tempY++));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    
    tempX = x+1;
    tempY = y+1;
    while (tempX < 8 && tempY < 8) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX++, tempY++));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempX = x-1;
    tempY = y-1;
    while (tempX >= 0 && tempY >= 0) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX--, tempY--));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempX = x+1;
    tempY = y-1;
    while (tempX < 8 && tempY >= 0) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX++, tempY--));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
    tempX = x-1;
    tempY = y+1;
    while (tempX >= 0 && tempY < 8) { 
      if (tempSquares[tempX][tempY] == null) {
        legalMoves.add(new PVector(tempX--, tempY++));
      } else if (tempSquares[tempX][tempY].dir*dir < 0) {
        if (tempSquares[tempX][tempY] instanceof King) {
          if (onBoard) {
            board.check = true;
          } else {
            board.checkCopy = true;  
          }
        } else {
          legalMoves.add(new PVector(tempX, tempY));
        }
        break; 
      } else if (tempSquares[tempX][tempY].dir*dir > 0) {
        break;  
      }
    }
  }
  
  void reduceLegalMoves() {
    for (int i = legalMoves.size()-1; i >= 0; i--) {
      if (board.simulatePosition(this, boardToPx(legalMoves.get(i)))) {
        legalMoves.remove(i);  
      }
    }  
  }
  
  void makeMove(PVector move, boolean onBoard) {
    super.makeMove(move, onBoard);
    if (onBoard) {
      squares[x][y] = this; 
      board.whiteTurn = !board.whiteTurn;
    } else {
      squaresCopy[x][y] = this;  
    }
  }
}
