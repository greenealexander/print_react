import React from 'react';
import ReactDOM from 'react-dom';
import { Router } from '@reach/router';
import socket from './socket';
import '../css/app.css';

import Nav from './pages/Nav';
import PrinterConfigurationDashboard from './pages/PrinterConfigurationDashboard';
import PrinterDashboard from './pages/PrinterDashboard';
import PrintJobsDashboard from './pages/PrintJobsDashboard';

const App = () => (
	<>
		<Nav />
		<main>
			<Router>
				<PrinterDashboard path="/app" />
				<PrinterConfigurationDashboard
					socket={socket}
					path="/app/printer-configurations"
				/>
				<PrintJobsDashboard path="/app/print-jobs" socket={socket} />
			</Router>
		</main>
	</>
);

ReactDOM.render(<App />, document.getElementById('app'));
