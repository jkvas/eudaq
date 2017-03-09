#include "eudaq/RunControl.hh"
#include <QAbstractListModel>
#include <vector>
#include <memory>

class RunControlModel : public QAbstractListModel {
  Q_OBJECT
public:
  RunControlModel(QObject *parent = 0);
  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  int columnCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QVariant headerData(int section, Qt::Orientation orientation,
                      int role) const override;
  void sort(int column, Qt::SortOrder order) override;
  
  void newconnection(eudaq::ConnectionSPC id);
  void disconnected(eudaq::ConnectionSPC id);
  void UpdateDisplayed();
  bool CheckConfigured();
  void SetStatus(eudaq::ConnectionSPC id, eudaq::StatusSPC status);
private:
  const std::vector<QString> m_str_header={"type", "name", "state", "connection", "info"};
  std::map<eudaq::ConnectionSPC, eudaq::StatusSPC> m_con_status;
  std::mutex m_mtx_con;
};
