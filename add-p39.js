module.exports = (id, name) => {
  qualifiers = {
    P2937: 'Q104767030', // 87th Legislature
  }

  return {
    id,
    claims: {
      P39: {
        value: 'Q18604553', // TX Representative
        qualifiers: qualifiers,
        references: {
          P854: 'https://house.texas.gov/members/',
          P1476: {
            text: 'House Members',
            language: 'en',
          },
          P813: new Date().toISOString().split('T')[0],
          P407: 'Q1860', // language: English
          P1810: name,
        }
      }
    }
  }
}
