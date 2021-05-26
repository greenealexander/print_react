import React, { useEffect, useState, useCallback } from 'react';
import PrinterConfigurationForm from './PrinterConfigurationForm';

import { joinChannel } from '../../utils';

const PrinterConfigurationDashboard = ({ socket }) => {
	const [configs, setConfigs] = useState([]);
	const [channel, setChannel] = useState(null);

	const receiveInitialConfigs = useCallback(({ configs }) =>
		setConfigs(configs),
	);
	const configAdded = useCallback((config) =>
		setConfigs((configs) => [...configs, config]),
	);
	const configDeleted = useCallback(({ name: deletedConfigName }) =>
		setConfigs((configs) =>
			configs.filter(({ name }) => name !== deletedConfigName),
		),
	);
	const onSubmit = useCallback((config) => {
		if (!channel) return;

		channel
			.push('configs_new', config)
			.receive('ok', (res) => {
				console.log('config added successfully!', res);
			})
			.receive('error', (res) => {
				console.log('failed to add config!', res);
			});
	});
	const onRemove = useCallback((name) => {
		channel
			.push('configs_delete', { name })
			.receive('ok', (res) => {
				console.log('config deleted successfully!', res);
			})
			.receive('error', (res) => {
				console.log('failed to delete config!', res);
			});
	});

	useEffect(() => {
		if (!socket) return;

		const channel = joinChannel(
			socket,
			'configs_channel',
			receiveInitialConfigs,
		);
		channel.on('configs_added', configAdded);
		channel.on('configs_deleted', configDeleted);
		setChannel(channel);

		return () => channel.leave();
	}, []);

	return (
		<>
			<header>
				<h2 style={{ padding: '8px 16px' }}>Printer Configurations</h2>
				<PrinterConfigurationForm
					style={{ maxWidth: 600 }}
					onSubmit={onSubmit}
				/>
			</header>

			{configs.length === 0 ? (
				<p style={{ padding: '8px 16px' }}>No configs</p>
			) : (
				<table>
					<thead>
						<tr>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>Name</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>
								Form Type
							</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>
								Printers
							</th>
						</tr>
					</thead>

					<tbody>
						{configs.map(({ name, formType, printers }) => (
							<tr key={name}>
								<td style={{ padding: '8px 16px' }}>{name}</td>
								<td style={{ padding: '8px 16px' }}>{formType}</td>
								<td style={{ padding: '8px 16px' }}>{printers.join()}</td>
								<td>
									<button
										onClick={() => onRemove(name)}
										style={{ padding: '8px 16px' }}
									>
										Delete
									</button>
								</td>
							</tr>
						))}
					</tbody>
				</table>
			)}
		</>
	);
};

export default PrinterConfigurationDashboard;
