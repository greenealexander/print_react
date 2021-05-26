import React, { useState, useCallback } from 'react';

const PrintJobForm = ({ style = {}, onSubmit = () => {} }) => {
	const [start, setStart] = useState('');
	const [end, setEnd] = useState('');

	const handleSubmit = useCallback((e) => {
		e.preventDefault();

		const submission = {};

		if (start === '') return;

		submission['start'] = start;

		if (end !== '') {
			submission['end'] = end;
		}

		onSubmit(submission);
		setStart('');
		setEnd('');
	});

	return (
		<form
			onSubmit={handleSubmit}
			style={{
				display: 'grid',
				gridTemplateColumns: 'repeat(2, 150px) 1fr',
				gridColumnGap: 16,
				gridRowGap: 8,
				padding: '8px 16px',
				...style,
			}}
		>
			<label>Start:</label>
			<label>End:</label>
			<div></div>

			<div>
				<input
					style={{ width: '100%' }}
					type="text"
					value={start}
					onChange={(e) => {
						if (e.target.value.length <= 5) {
							setStart(e.target.value);
						}
					}}
				/>
			</div>
			<div>
				<input
					style={{ width: '100%' }}
					type="text"
					value={end}
					onChange={(e) => {
						if (e.target.value.length <= 5) {
							setEnd(e.target.value);
						}
					}}
				/>
			</div>
			<div>
				<button style={{ padding: '8px 16px' }}>Add</button>
			</div>
		</form>
	);
};

export default PrintJobForm;
