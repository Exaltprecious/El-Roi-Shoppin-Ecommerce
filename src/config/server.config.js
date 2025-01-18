let serverPort = 4000;

if(process.env.NODE_ENV !== 'development'){
	serverPort = process.env.PORT
}
export default serverPort;
