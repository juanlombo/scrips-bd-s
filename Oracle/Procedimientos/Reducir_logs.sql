tail -n 10000 listener.log > listener1.log  
cp listener1.log listener.log  
rm -rf listener1.log
 
 
tail -n 10000 listener_scan1.log > listener1.log 
cp listener1.log listener_scan1.log 
rm -rf listener1.log
