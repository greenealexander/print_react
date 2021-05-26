import React, { useState, useCallback, useEffect } from 'react';
import axios from 'axios';

const formTypes = ['Payroll', 'YearEnd'];

const PrinterConfigurationForm = ({ style = {}, onSubmit = () => {} }) => {
	const [name, setName] = useState('');
	const [formType, setFormType] = useState(formTypes[0]);
	const [selectedPrinters, setSelectedPrinters] = useState([]);
	const [printers, setPrinters] = useState([]);

	const handleSubmit = useCallback((e) => {
		e.preventDefault();

		if (name === '' || selectedPrinters.length === 0) return;

		onSubmit({ name, formType, printers: selectedPrinters });
		setName('');
	});

	useEffect(() => {
		axios
			.get('http://localhost:4000/api/printers')
			.then(({ data }) => setPrinters(data));
	}, []);

	return (
		<form
			onSubmit={handleSubmit}
			style={{
				display: 'grid',
				gridTemplateColumns: 'repeat(3, 1fr) 80px',
				gridColumnGap: 16,
				gridRowGap: 8,
				padding: '8px 16px',
				...style,
			}}
		>
			<label>Name:</label>
			<label>Form Type:</label>
			<label>Printers:</label>
			<div></div>

			<div>
				<input
					style={{ width: '100%' }}
					type="text"
					value={name}
					onChange={(e) => setName(e.target.value)}
				/>
			</div>
			<div>
				<select
					style={{ width: '100%' }}
					value={formType}
					onChange={(e) => setFormType(e.target.value)}
				>
					{formTypes.map((type) => (
						<option key={type} value={type}>
							{type}
						</option>
					))}
				</select>
			</div>
			<select
				multiple
				value={selectedPrinters}
				onChange={(e) =>
					setSelectedPrinters(
						Array.prototype.slice
							.call(e.target.selectedOptions)
							.map(({ value }) => value),
					)
				}
			>
				{printers.map(({ name }) => (
					<option key={name} style={{ padding: '4px' }} value={name}>
						{name}
					</option>
				))}
			</select>
			<div>
				<button style={{ padding: '8px 16px', width: '100%' }}>Add</button>
			</div>
		</form>
	);
};

export default PrinterConfigurationForm;
