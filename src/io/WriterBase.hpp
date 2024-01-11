#pragma once

#include "HydroUniformGrid.hpp"
#include "HydroParams.hpp"
#include "HydroTypes.hpp"
#include "global_meanExecution.hpp"
#include "vp2Execution.hpp"

#include <utility>
#include <vector>

namespace hydro { namespace io
{

class WriterBase
{
public:
    WriterBase() = default;
    WriterBase(const WriterBase& x) = default;
    WriterBase(WriterBase&& x) = default;
    virtual ~WriterBase() = default;
  //  WriterBase& operator=(const WriterBase& x) = default;
  //  WriterBase& operator=(WriterBase&& x) = default;

    virtual void write(HostConstArrayDyn u, const UniformGrid& grid,
                       Int iStep, Real time, Real gamma, Real mmw) = 0;

    virtual void write_mean(global_mean)
    {
        throw std::runtime_error("Writing mean is not implemented");
    }

    virtual void write_profile(void*, const UniformGrid&)
    {
        throw std::runtime_error("Writing profile is not implemented");
    }

    virtual void write_slice(const UniformGrid&, void*, void*, bool)
    {
        throw std::runtime_error("Writing slice is not implemented");
    }

    void setOutputId(Int id)
    {
        m_outputId = id;
    }
    void setRestartId(Int id)
    {
        m_restartId = id;
    }
protected:
    Int m_outputId = 0;
    Int m_restartId = 0;
    std::vector<std::pair<Int, Real>> m_previous_outputs = {};
};

}}
