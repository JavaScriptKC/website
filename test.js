var rest = require('restler')
var parser = require('./utility/atomParser.js')

rest.get('http://www.google.com/calendar/feeds/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic').on('complete', function(d) {console.log(parser(d))});

