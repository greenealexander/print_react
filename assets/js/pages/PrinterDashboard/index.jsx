import React, { useEffect, useState } from 'react';
import axios from 'axios';

import MarkerLevels from './MarkerLevels';

const PrinterDashboard = () => {
	const [printers, setPrinters] = useState([]);

	useEffect(() => {
		axios
			.get('http://localhost:4000/api/printers')
			.then(({ data }) => setPrinters(data));
	}, []);

	return (
		<div>
			<h2 style={{ padding: '8px 16px' }}>Printers</h2>
			<ul>
				{printers.map(({ name, state, iconUrl, markers }) => (
					<li
						key={name}
						style={{
							display: 'flex',
							alignItems: 'center',
							gap: 16,
							padding: '8px 16px',
						}}
					>
						<img
							src={iconUrl}
							alt={name + 'icon'}
							style={{ objectFit: 'fill', width: 50 }}
						/>
						<span style={{ fontWeight: 'bold' }}>{name}</span>
						<span>{state.toUpperCase()}</span>
						<MarkerLevels markers={markers} />
					</li>
				))}
			</ul>
		</div>
	);
};

export default PrinterDashboard;
