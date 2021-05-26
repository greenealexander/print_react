import React, { useState, useEffect, useCallback } from 'react';

import JobRow from './JobRow';
import PrintJobForm from './PrintJobForm';
import { joinChannel } from '../../utils';

const PrintJobsDashboard = ({ socket }) => {
	const [state, setState] = useState({ jobRows: [], lookup: {} });
	const [channel, setChannel] = useState(null);

	const receiveInitialJobRows = useCallback(({ job_rows }) => {
		setState((_) => ({
			jobRows: job_rows,
			lookup: job_rows.reduce((total, curr, i) => {
				total[curr.startCode] = i;
				return total;
			}, {}),
		}));
	});
	const jobRowAdded = useCallback(({ index, jobRow }) => {
		console.log('job row added');

		setState(({ jobRows }) => {
			const updatedJobRows = [...jobRows];
			updatedJobRows.splice(index, 0, jobRow);
			const updatedLookup = updatedJobRows.reduce((total, curr, i) => {
				total[curr.startCode] = i;
				return total;
			}, {});
			return { jobRows: updatedJobRows, lookup: updatedLookup };
		});
	});
	const onSubmit = useCallback(({ start, end }) => {
		if (!channel) return;

		channel
			.push('print_job_rows_new', {
				startCode: start,
				endCode: end,
				documents: Array.from({
					length: Math.floor(Math.random() * 20) + 1,
				}).map((_, i) => ({
					code: start,
					docPath: `path/to/file/${start}-${i + 1}.pdf`,
					pageCount: Math.floor(Math.random() * 100) + 1,
				})),
			})
			.receive('ok', (res) => {
				console.log('jobRow added successfully!', res);
			})
			.receive('error', (res) => {
				console.log('failed to add jobRow!', res);
			});
	});

	const startJobRow = useCallback((startCode) => {
		if (!channel) return;

		channel
			.push('print_job_rows_start', { startCode })
			.receive('ok', (res) => {
				console.log('jobRow started successfully!', res);
				setState(({ jobRows, lookup }) => {
					const index = lookup[startCode];
					const jobRowsCopy = [...jobRows];
					jobRowsCopy[index].state = 'Printing';
					return { jobRows: jobRowsCopy, lookup };
				});
			})
			.receive('error', (res) => {
				console.log('failed to start jobRow!', res);
			});
	});

	const pagePrinted = useCallback(({ startCode }) => {
		console.log('page printed');

		setState(({ jobRows, lookup }) => {
			const index = lookup[startCode];
			const jobRowsCopy = [...jobRows];
			jobRowsCopy[index].pagesCompleted += 1;
			return { jobRows: jobRowsCopy, lookup };
		});
	});

	const jobRowCompleted = useCallback(({ startCode }) => {
		console.log('job row completed');

		setState(({ jobRows, lookup }) => {
			const index = lookup[startCode];
			const jobRowsCopy = [...jobRows];
			jobRowsCopy[index].state = 'Printed';
			return { jobRows: jobRowsCopy, lookup };
		});
	});

	const jobRowStarted = useCallback(({ startCode }) => {
		console.log('job row started');

		setState(({ jobRows, lookup }) => {
			const index = lookup[startCode];
			const jobRowsCopy = [...jobRows];
			jobRowsCopy[index].state = 'Printing';
			return { jobRows: jobRowsCopy, lookup };
		});
	});

	useEffect(() => {
		if (!socket) return;

		const channel = joinChannel(
			socket,
			'print_job_rows_channel',
			receiveInitialJobRows,
		);
		channel.on('print_job_rows_added', jobRowAdded);
		channel.on('print_job_rows_page_printed', pagePrinted);
		channel.on('print_job_row_completed', jobRowCompleted);
		channel.on('print_job_rows_started', jobRowStarted);
		setChannel(channel);

		return () => channel.leave();
	}, []);

	return (
		<>
			<header>
				<h2 style={{ padding: '8px 16px' }}>Print Jobs</h2>
				<PrintJobForm onSubmit={onSubmit} />
			</header>

			{state.jobRows.length === 0 ? (
				<p style={{ padding: '8px 16px' }}>No job rows</p>
			) : (
				<table>
					<thead>
						<tr>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>Start</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>End</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>
								Printer Config
							</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>
								Documents
							</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>Pages</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>
								Completed
							</th>
							<th style={{ padding: '8px 16px', textAlign: 'left' }}>State</th>
						</tr>
					</thead>

					<tbody>
						{state.jobRows.map((props) => (
							<JobRow key={props.startCode} {...props} onStart={startJobRow} />
						))}
					</tbody>
				</table>
			)}
		</>
	);
};

export default PrintJobsDashboard;
