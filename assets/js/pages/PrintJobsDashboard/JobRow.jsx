import React from 'react';

const JobRow = ({
	startCode,
	endCode,
	state,
	pageCount,
	pagesCompleted,
	printerConfigName,
	documentCount,
	onStart = () => {},
}) => (
	<tr key={startCode}>
		<td style={{ padding: '8px 16px' }}>{startCode}</td>
		<td style={{ padding: '8px 16px' }}>{endCode}</td>
		<td style={{ padding: '8px 16px' }}>{printerConfigName}</td>
		<td style={{ padding: '8px 16px' }}>{documentCount}</td>
		<td style={{ padding: '8px 16px' }}>{pageCount}</td>
		<td style={{ padding: '8px 16px' }}>{pagesCompleted}</td>
		<td style={{ padding: '8px 16px' }}>{state}</td>
		<td>
			<button
				style={{ padding: '8px 16px' }}
				onClick={() => onStart(startCode)}
			>
				Start
			</button>
		</td>
		<td>
			<button style={{ padding: '8px 16px' }}>Delete</button>
		</td>
	</tr>
);

export default JobRow;
