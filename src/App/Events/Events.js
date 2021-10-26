sendMessage = (parent, event) =>
    parent.dispatchEvent(event)

createEvent = (eventName, message, data) =>
    new CustomEvent(eventName, { detail: { [message]: data } });

receiveMessage = (target) => (eventName) => (message) => () => new Promise(res =>
    target.addEventListener(eventName, resolver = ({ detail }) => {
        if (detail.message == message) {
            target.removeEventListener(eventName, resolver);
            res(detail.body);
        }
    })
);

exports.receiveMessage = receiveMessage

exports.getLang = props => message => data => () => new Promise(res => {
    receiveMessage(props.target)(props.eventName)(data)().then(data => res(data));
    sendMessage(props.parent, createEvent(props.eventName, message, data));
});