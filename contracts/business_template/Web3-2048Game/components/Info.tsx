import React from 'react';

const Info: React.FC = () => {
  return (
    <div className="info">
      <h2>About</h2>
      <p>
        This is a reimplementation of Gabriele Cirulli's excellent{' '}
        <a href="https://play2048.co/">2048</a> game, built with React, Redux
        and TypeScript. Unlike other React-based implementations, only
        functional components are used here. This project doesn't rely on canvas
        or element refs.
      </p>
      <p>
        Developed by <a href="https://github.com/mat-sz">Mat Sz</a>. Source code
        available at <a href="https://github.com/mat-sz/2048">mat-sz/2048</a>.
      </p>
    </div>
  );
};

export default Info;
