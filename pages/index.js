import React, { useState } from 'react';
import Head from 'next/head';
import { createConsorcio } from '../utils/contractInteraction';

export default function Home() {
  const [name, setName] = useState('');
  const [totalValue, setTotalValue] = useState('');
  const [monthlyPayment, setMonthlyPayment] = useState('');
  const [numberOfParticipants, setNumberOfParticipants] = useState('');
  const [message, setMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const success = await createConsorcio(name, totalValue, monthlyPayment, numberOfParticipants);
    if (success) {
      setMessage('Consorcio created successfully!');
    } else {
      setMessage('Failed to create consorcio. Please try again.');
    }
  };

  return (
    <div className="container">
      <Head>
        <title>Consorcio Manager</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        <h1 className="title">Welcome to Consorcio Manager</h1>
        <p className="description">Manage your consórcios with ease</p>

        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Consorcio Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
          <input
            type="number"
            placeholder="Total Value"
            value={totalValue}
            onChange={(e) => setTotalValue(e.target.value)}
            required
          />
          <input
            type="number"
            placeholder="Monthly Payment"
            value={monthlyPayment}
            onChange={(e) => setMonthlyPayment(e.target.value)}
            required
          />
          <input
            type="number"
            placeholder="Number of Participants"
            value={numberOfParticipants}
            onChange={(e) => setNumberOfParticipants(e.target.value)}
            required
          />
          <button type="submit">Create Consorcio</button>
        </form>

        {message && <p className="message">{message}</p>}
      </main>

      <style jsx>{`
        .container {
          min-height: 100vh;
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }
        main {
          padding: 5rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }
        .title {
          margin: 0;
          line-height: 1.15;
          font-size: 4rem;
          text-align: center;
        }
        .description {
          text-align: center;
          line-height: 1.5;
          font-size: 1.5rem;
        }
        form {
          display: flex;
          flex-direction: column;
          margin-top: 2rem;
        }
        input {
          margin: 0.5rem 0;
          padding: 0.5rem;
          font-size: 1rem;
        }
        button {
          margin-top: 1rem;
          padding: 0.5rem;
          font-size: 1rem;
          background-color: #0070f3;
          color: white;
          border: none;
          cursor: pointer;
        }
        .message {
          margin-top: 1rem;
          font-size: 1.2rem;
          color: #0070f3;
        }
      `}</style>
    </div>
  );
}
