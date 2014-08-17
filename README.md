Smoothier
=========


```
var play = function(track_id){
  SC.get('/tracks/'+track_id, function(track){
    SC.oEmbed(track.permalink_url, {}, $('body').get(0));
  });
}
```