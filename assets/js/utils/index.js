export const joinChannel = (socket, channelName, onReceive) => {
	const channel = socket.channel(channelName);
	channel.join().receive('ok', onReceive);
	return channel;
};
