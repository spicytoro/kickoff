local Queue = require("Queue")
_colors = Queue.new()

_doneDeleting = true; 
_group = nil; 
_combo = 1
_noShrink = false; 
_waveNumber = 4; 
_pickedUp = nil;
_board = nil; 
_nextBlocks = nil
--_nextBlocksTop = nil
_placed = true; 
_gotLine = false; 
_squareSize = 88; 
_score = 0; 
_added = false;
_gameOver = false; 