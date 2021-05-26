import React from 'react';

const MarkerLevels = ({ markers }) => {
	const { colors, highLevels, lowLevels, levels, names } = markers;
	const percentage = (curr, high, idx) => curr[idx] / high[idx];

	return (
		<>
			{names.map((name, i) => {
				const percent = percentage(levels, highLevels, i);
				const hasLowInk = levels[i] === lowLevels[i];

				return (
					<div
						key={i}
						title={`${name} - ${percent * 100}% ${hasLowInk ? '(low)' : ''}`}
						style={{
							border: '1px solid black',
							width: 50,
							position: 'relative',
						}}
					>
						<div
							style={{
								backgroundColor: colors[i],
								height: 16,
								width: 50 * percent,
							}}
						/>

						{hasLowInk && (
							<img
								src="/images/caution.png"
								alt="low-ink"
								style={{
									width: 14,
									position: 'absolute',
									left: 25 - 8,
									top: 1,
								}}
							/>
						)}
					</div>
				);
			})}
		</>
	);
};

export default MarkerLevels;
