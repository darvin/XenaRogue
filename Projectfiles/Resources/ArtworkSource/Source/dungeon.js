
var tileSet = {
    image:          null,
    imageFilename:  "dungeon.png",
    tileCount:      256,
    tilesPerRow:    16,
    tileOrigin:     { x: 0, y: 40 },
    tileSize:       { width: 16, height: 16 },
    
    drawTile:       function( context, tile, x, y )
                    {
                        if( tile == undefined ) return;
                        if( tile < 0 || tile >= this.tileCount ) return;
                        if( x < 0 || y < 0 ) return;
                        if( x + this.tileSize.width >= context.canvas.width ) return;
                        if( y + this.tileSize.height >= context.canvas.height ) return;
                        
                        var row = Math.floor( tile / this.tilesPerRow );
                        var col = Math.floor( tile % this.tilesPerRow );
                        
                        var dx = this.tileOrigin.x + col * this.tileSize.width;
                        var dy = this.tileOrigin.y + row * this.tileSize.height;
                        
                        context.drawImage( this.image, dx, dy, this.tileSize.width, this.tileSize.height,
                            x, y, this.tileSize.width, this.tileSize.height );
                    },
                    
    drawTile2x:     function( context, tile, x, y )
                    {
                        if( tile == undefined ) return;
                        if( tile < 0 || tile >= this.tileCount ) return;
                        if( x < 0 || y < 0 ) return;
                        if( x + this.tileSize.width >= context.canvas.width ) return;
                        if( y + this.tileSize.height >= context.canvas.height ) return;
                        
                        var row = Math.floor( tile / this.tilesPerRow );
                        var col = Math.floor( tile % this.tilesPerRow );
                        
                        var dx = this.tileOrigin.x + col * this.tileSize.width;
                        var dy = this.tileOrigin.y + row * this.tileSize.height;
                        
                        context.drawImage( this.image, dx, dy, this.tileSize.width, this.tileSize.height,
                            x, y, this.tileSize.width*2, this.tileSize.height*2 );
                    },
                    
    asciiTable: {
        " ": "empty",
        ".": "floor",
        "T": "wall",
        "#": "ceiling",
        "~": "lava",
        "X": "pit",
    },
    
    type: {
        empty: {
            typeStr: "empty",
            defaultTileIndex: 0,
            toString: function() { return "[empty]"; },
            rules: [],
        },
        
        floor: {
            typeStr: "floor",
            defaultTileIndex: 1,
            toString: function() { return "[floor]"; },
            rules: [
                { tileIndex: 33, map: { w:"ceiling", nw:"NIL" } },
                { tileIndex: 33, map: { w:"ceiling", sw:"NIL" } },
                { tileIndex: 49, map: { w:"wall", sw:"floor" } },
                { tileIndex: 17, map: { w:"ceiling", nw:"floor" } },
                { tileIndex: 33, map: { w:"wall" } },
                { tileIndex: 33, map: { w:"ceiling" } },
            ],
        },
        
        wall: {
            typeStr: "wall",
            defaultTileIndex: 2,
            toString: function() { return "[wall]"; },
            rules: [
                { tileIndex: 2, map: { w:"wall", e:"wall" } },
                { tileIndex: 2, map: { w:"wall", e:"ceiling" } },
                
                { tileIndex: 4, map: { w:"floor", e:"wall" } },
                { tileIndex: 4, map: { w:"floor", e:"ceiling" } },
                { tileIndex: 5, map: { w:"wall", e:"floor" } },
                { tileIndex: 5, map: { w:"ceiling", e:"floor" } },
                
                
                { tileIndex: 18, map: { w:"ceiling", n:"ceiling", e:"wall" } },
                { tileIndex: 18, map: { w:"ceiling", n:"ceiling", e:"ceiling" } },
                { tileIndex: 19, map: { w:"ceiling", n:"ceiling", e:"floor" } },
                
                { tileIndex: 34, map: { w:"ceiling", n:"wall", e:"wall" } },
                { tileIndex: 35, map: { w:"ceiling", n:"wall", e:"floor"} },
                
                
                { tileIndex: 19, map: { w:"ceiling", n:"ceiling", e:"!wall" } },
                { tileIndex: 35, map: { w:"ceiling", n:"wall", e:"!wall" } },
                { tileIndex: 4, map: { w:"!wall", e:"wall" } },
                { tileIndex: 5, map: { w:"wall", e:"!wall" } },
                { tileIndex: 3, map: { w:"!wall", e:"!wall" } },
            ]
        },
        
        ceiling: {
            typeStr: "ceiling",
            defaultTileIndex: 27,
            toString: function() { return "[ceiling]"; },
            rules: [
            
                // Put this rule up top to make clearing screen faster.
                { tileIndex: 24, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                
                // --- Row 1 ---
                { tileIndex:  6, map: { nw:"!ceiling", n:"!ceiling", ne:"!ceiling", w:"!ceiling", e:"!ceiling", s:"ceiling"} },
                { tileIndex:  7, map: { n:"!ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex:  8, map: { n:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex:  9, map: { n:"!ceiling", w:"ceiling", e:"!ceiling", sw:"ceiling", s:"ceiling" } },
                { tileIndex: 10, map: { n:"!ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 11, map: { n:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 12, map: { n:"!ceiling", w:"ceiling", e:"!ceiling", sw:"!ceiling", s:"ceiling" } },
                { tileIndex: 13, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"!ceiling"} },
                { tileIndex: 14, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"!ceiling"} },
                { tileIndex: 15, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"ceiling"} },
                
                // --- Row 2 ---
                { tileIndex: 22, map: { n:"ceiling", w:"!ceiling", e:"!ceiling", s:"ceiling" } },
                { tileIndex: 23, map: { n:"ceiling", ne:"ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"ceiling" } },
                //{ tileIndex: 24, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 25, map: { nw:"ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", sw:"ceiling", s:"ceiling" } },
                { tileIndex: 26, map: { n:"ceiling", ne:"!ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 27, map: { nw:"!ceiling", n:"!ceiling", ne:"!ceiling", w:"!ceiling", e:"!ceiling", sw:"!ceiling", s:"!ceiling", se:"!ceiling" } },
                { tileIndex: 28, map: { nw:"!ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", sw:"!ceiling", s:"ceiling" } },
                { tileIndex: 29, map: { nw:"ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 30, map: { nw:"!ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 31, map: { nw:"!ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"ceiling" } },
                
                // --- Row 3 ---
                { tileIndex: 38, map: { n:"ceiling", w:"!ceiling", e:"!ceiling", s:"!ceiling" } },
                { tileIndex: 39, map: { n:"ceiling", ne:"ceiling", w:"!ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 40, map: { nw:"ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 41, map: { nw:"ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", s:"!ceiling" } },
                { tileIndex: 42, map: { n:"ceiling", ne:"!ceiling", w:"!ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 43, map: { nw:"!ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 44, map: { nw:"!ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", s:"!ceiling" } },
                { tileIndex: 45, map: { nw:"ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 46, map: { nw:"!ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 47, map: { nw:"!ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"ceiling" } },
                
                // --- Row 4 ---
                { tileIndex: 55, map: { n:"!ceiling", w:"!ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 56, map: { n:"!ceiling", w:"ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 57, map: { n:"!ceiling", w:"ceiling", e:"!ceiling", s:"!ceiling" } },
                { tileIndex: 58, map: { n:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 59, map: { nw:"ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", sw:"!ceiling", s:"ceiling" } },
                { tileIndex: 60, map: { n:"ceiling", ne:"ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 61, map: { n:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 62, map: { nw:"ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 63, map: { nw:"!ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"!ceiling" } },
                
                // --- Row 5 ---
                { tileIndex: 72, map: { nw:"ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 73, map: { nw:"!ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 74, map: { n:"ceiling", ne:"!ceiling", w:"!ceiling", e:"ceiling", s:"ceiling", se:"ceiling" } },
                { tileIndex: 75, map: { nw:"!ceiling", n:"ceiling", ne:"ceiling", w:"ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 76, map: { nw:"ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", s:"!ceiling" } },
                { tileIndex: 77, map: { nw:"!ceiling", n:"ceiling", w:"ceiling", e:"!ceiling", sw:"ceiling", s:"ceiling" } },
                { tileIndex: 78, map: { nw:"!ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"ceiling", s:"ceiling", se:"!ceiling" } },
                { tileIndex: 79, map: { nw:"!ceiling", n:"ceiling", ne:"!ceiling", w:"ceiling", e:"ceiling", sw:"!ceiling", s:"ceiling", se:"ceiling" } },
            ],
        },
        
        lava: {
            typeStr: "lava",
            defaultTileIndex: 50,
            toString: function() { return "[lava]"; },
            rules: [
                { tileIndex: 85, map: { n:"lava", w:"lava", nw:"!lava" } },
                { tileIndex: 83, map: { w:"!lava", n:"!lava", sw:"!lava" } },
                { tileIndex: 83, map: { w:"!lava", n:"!lava", sw:"lava" } },
                { tileIndex: 66, map: { nw:"lava", w:"!lava", sw:"lava" } },
                { tileIndex: 66, map: { nw:"lava", w:"!lava" } },
                { tileIndex: 82, map: { nw:"!lava", w:"!lava", sw:"!lava" } },
                { tileIndex: 82, map: { nw:"!lava", w:"!lava", sw:"lava" } },
                { tileIndex: 51, map: { n:"!lava" } },
            ],
        },
        
        pit: {
            typeStr: "pit",
            defaultTileIndex: 0,
            toString: function() { return "[pit]"; },
            rules: [
                { tileIndex: 16, map: { n:"!pit" } },
            ],
        },
            
    }
};