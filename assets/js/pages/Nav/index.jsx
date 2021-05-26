import React from 'react';
import { Link } from '@reach/router';

const links = [
	{ path: '/app', text: 'Printers' },
	{ path: '/app/printer-configurations', text: 'Printer Configurations' },
	{ path: '/app/print-jobs', text: 'Print Jobs' },
];

const Nav = () => (
	<nav style={{ display: 'flex', flexDirection: 'column' }}>
		<h2 style={{ color: 'gray', padding: '8px 16px' }}>PUP</h2>
		{links.map(({ path, text }) => (
			<Link
				key={path}
				to={path}
				getProps={({ isCurrent }) => ({
					style: {
						color: isCurrent ? 'white' : 'black',
						backgroundColor: isCurrent ? '#333' : 'transparent',
						padding: '8px 16px',
					},
				})}
			>
				{text}
			</Link>
		))}
	</nav>
);

export default Nav;
